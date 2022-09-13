require "hashcash"
require "http/client"
require "json"
require "tasker"
require "ulid"
require "ed25519"
require "simple_retry"

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
    getter domain : String
    getter name : String
    getter email : String
    getter instance_id : String
    getter instance_token : String?
    getter registered : Bool = false

    private getter heartbeat_task : Tasker::Repeat(HTTP::Client::Response)?
    private getter heartbeat_interval : Time::Span

    private getter private_key : Ed25519::SigningKey

    getter api_base : String

    ROUTE_BASE = "/api/portal/v1/"

    def initialize(
      @instance_token : String?,
      @email : String,
      private_key : String | Ed25519::SigningKey,
      @instance_id : String = ULID.generate,
      @saas : Bool = false,
      portal_uri : String = PLACE_PORTAL_URI,
      @domain : String = PLACE_DOMAIN,
      @name : String = PLACE_PULSE_INSTANCE_NAME,
      @heartbeat_interval : Time::Span = 6.hours
    )
      @private_key = case private_key
                     in Ed25519::SigningKey then private_key
                     in String              then Ed25519::SigningKey.new(private_key.hexbytes)
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
        domain: @domain,
        name: @name,
        email: email,
        instance_id: instance_id,
        public_key: @private_key.verify_key.to_slice.hexstring
      )

      post("/register", RegisterRequest.new(instance_id, saas?, register_message, @private_key))

      if saas?
        if token = instance_token
          token_message = Token.new(token)

          # we really want this to succeed.
          # on failure we should delete the API key token
          SimpleRetry.try_to(
            max_attempts: 20,
            base_interval: 10.milliseconds,
            max_interval: 10.seconds,
          ) do
            post("/instances/#{instance_id}/token", TokenRequest.new(
              instance_id, saas?, token_message, @private_key
            ))
          end
        end
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
