require "hashcash"
require "http/client"
require "json"
require "tasker"
require "ulid"

require "responsible"

require "./constants"

module PlaceOS::Pulse
  include Responsible

  # Handles registration and periodic telemtry reporting
  #
  class Client
    getter? saas : Bool
    getter instance_id : String
    getter private_key : String
    getter registered : Bool = false

    private getter heartbeat_task : Tasker::Repeat(HTTP::Client::Response)?
    private getter heartbeat_interval : Time::Span

    getter api_base : String

    ROUTE_BASE = "/api/portal/v1/"

    def initialize(
      @instance_token : String,
      @instance_id : String = ULID.generate,
      @saas : Bool = false,
      portal_uri : String = PLACE_PORTAL_URI,
      @heartbeat_interval : Time::Span = 6.hours
    )
      @api_base = File.join(portal_uri, ROUTE_BASE)
    end

    def start
      register
      @heartbeat_task = Tasker.every(heartbeat_interval) { heartbeat }
    end

    def stop
      heartbeat_task.try &.stop
    end

    protected def heartbeat
      put("/#{instance_id}/heartbeat", Hearbeat.from_database)
    end

    # Register the instance.
    #
    # If the instance is a Saas instance, it forwards an instance API token.
    #
    # The API token enables external control of the intance.
    protected def register : Nil
      post("/register", Register.generate(
        token: instance_token,
        public_key: public_key,
        instance_id: instance_id,
      ))

      if saas?
        post("/instances/#{instance_id}/new_key", Message::Token.new(instance_token))
      end
    end

    # Encrypt this instance's JWT_PRIVATE_KEY using the passed in public key
    def encrypt_jwt_key(portal_public_key : String) : String
      # This is for encryption so use CryptoBox not Sign
      key = Sodium::CryptoBox::PublicKey.new(portal_public_key.hexbytes)
      String.new(key.encrypt(JWT_PRIVATE_KEY))
    end

    def public_key : String
      Sodium::Sign::SecretKey.new(@private_key.hexbytes).public_key.to_slice.hexstring
    end

    protected def message(request : Request)
      Message.new(instance_id, saas?, request)
    end

    {% for verb in ["post", "put"] %}
      protected def {{ verb.id }}(path : String, request : Message::Request)
        HTTP::Client.{{verb.id}}(File.join(api_base, path), body: message(request).to_json)).tap do |response|
          unless response.status.ok? || response.status.created?
            # TODO: Create error class
            raise("Register Request Failed with #{response.status_code}:\n#{response.body}")
          end
        end
      end
    {% end %}
  end
end
