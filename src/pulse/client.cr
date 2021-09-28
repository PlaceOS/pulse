require "tasker"

module Pulse
  # Handles registration and periodic telemtry reporting
  #
  class Client
    getter saas : Bool
    getter instance_id : String
    getter private_key : String
    getter registered : Bool = false
    getter task : Tasker::Repeat(HTTP::Client::Response)

    def initialize(
      @saas : Bool = false,
      instance_id : String? = nil,
      private_key : String? = nil,
      heartbeat_interval : Time::Span = 6.hours
    )
      # Gab: First we need to register the new pulse client in the portal.
      # Gab: If no ID and private key are passed in then this will be created in the registration class

      # FIXME: Register should be a message just like any other and sent via this client
      registration = Pulse::Register.new(@saas, instance_id, private_key)

      # Gab: Make the call to actually register this instance
      @registered = registration.portal_request

      @instance_id = registration.instance_id

      @private_key = registration.private_key

      @task = Tasker.every(heartbeat_interval) { heartbeat }
    end

    def heartbeat
      # FIXME: The client should handle sending messages, not the message itself
      Message.new(
        @instance_id,
        @private_key,
      ).send("/heartbeat")
    end
  end
end
