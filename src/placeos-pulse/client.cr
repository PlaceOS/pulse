require "hashcash"
require "http/client"
require "json"
require "tasker"
require "ulid"
require "sodium"

require "responsible"

require "./constants"
require "./error"
require "./message/response"

module PlaceOS::Pulse
  include Responsible

  # Handles registration and periodic telemtry reporting
  #
  class Client
    getter? saas : Bool
    getter email : String
    getter instance_id : String
    getter instance_token : String
    getter registered : Bool = false

    private getter heartbeat_task : Tasker::Repeat(HTTP::Client::Response)?
    private getter heartbeat_interval : Time::Span

    getter api_base : String

    ROUTE_BASE = "/api/portal/v1/"

    def initialize(
      @instance_token : String,
      @email : String,
      @private_key : Sodium::Sign::SecretKey,
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
      put("/instances/#{instance_id}/heartbeat", Message::Heartbeat.from_database)
    end

    # Register the instance.
    #
    # If the instance is a Saas instance, it forwards an instance API token.
    #
    # The API token enables external control of the intance.
    protected def register : Nil
      post("/register", Message::Register.generate(
        email: email,
        instance_id: instance_id,
      ))

      if saas?
        post("/instances/#{instance_id}/token", Message::Token.new(instance_token))
      end

      @registered = true
    end

    protected def message(request : Request)
      Message.new(instance_id, saas?, request, @private_key)
    end

    {% for verb in ["post", "put"] %}
      protected def {{ verb.id }}(path : String, request : Request)
        HTTP::Client.{{verb.id}}(File.join(api_base, path), body: message(request).to_json).tap do |response|
          unless response.status.ok? || response.status.created?
            raise Error.new(request, response)
          end
        end
      end
    {% end %}
  end
end
