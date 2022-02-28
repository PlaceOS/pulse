require "hashcash"
require "http/client"
require "json"
require "tasker"
require "ulid"
require "sodium"

require "responsible"

require "./constants"
require "./error"
require "./response"

module PlaceOS::Pulse
  include Responsible

  # Handles registration and periodic telemtry reporting
  #
  class Client
    getter? saas : Bool
    getter email : String
    getter instance_id : String
    getter instance_token : String?
    getter registered : Bool = false

    private getter heartbeat_task : Tasker::Repeat(HTTP::Client::Response)?
    private getter heartbeat_interval : Time::Span

    private getter private_key : Sodium::Sign::SecretKey

    getter api_base : String

    ROUTE_BASE = "/api/portal/v1/"

    def initialize(
      @instance_token : String?,
      @email : String,
      private_key : String | Sodium::Sign::SecretKey,
      @instance_id : String = ULID.generate,
      @saas : Bool = false,
      portal_uri : String = PLACE_PORTAL_URI,
      @instance_domain : String = PLACE_DOMAIN,
      @instance_name : String = PLACE_PULSE_INSTANCE_NAME,
      @heartbeat_interval : Time::Span = 6.hours
    )
      @private_key = case private_key
                     in Sodium::Sign::SecretKey then private_key
                     in String                  then Sodium::Sign::SecretKey.new(private_key.hexbytes)
                     end

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
      message = Heartbeat.from_database
      put("/instances/#{instance_id}/heartbeat", HeartbeatRequest.new(
        instance_id, saas?, message, @private_key
      ))
    end

    # Register the instance.
    #
    # If the instance is a Saas instance, it forwards an instance API token.
    #
    # The API token enables external control of the intance.
    protected def register : Nil
      register_message = Register.generate(
        domain: @instance_domain,
        name: @instance_name,
        email: email,
        instance_id: instance_id,
        public_key: @private_key.public_key.to_slice.hexstring
      )

      post("/register", RegisterRequest.new(instance_id, saas?, register_message, @private_key))

      if saas?
        if (token = instance_token).nil?
          raise Error.new("Missing instance token for saas instance.")
        end
        token_message = Token.new(token)

        post("/instances/#{instance_id}/token", TokenRequest.new(
          instance_id, saas?, token_message, @private_key
        ))
      end

      @registered = true
    end

    {% for verb in ["post", "put"] %}
      protected def {{ verb.id }}(path : String, request : Message(T)) forall T
        HTTP::Client.{{verb.id}}(File.join(api_base, path), body: request.to_json).tap do |response|
          unless response.status.ok? || response.status.created?
            raise Error.new(request, response)
          end
        end
      end
    {% end %}
  end
end
