module Pulse
  #
  # Pulse::Client will be used to bring together the other aspects of pulse including
  # the Register, Heartbeat and Message classes. It will manage the task of creating heartbeats
  class Client
    getter instance_id : String?
    getter private_key : String?
    getter task : Tasker::Repeat(HTTP::Client::Response)

    def initialize(@saas : Bool = false, @instance_id=nil, @private_key=nil, heartbeat_interval : Time::Span = 1.day)
      # First we need to register the new pulse client in the portal
      # If no ID and private key are passed in then this will be created in the registration class
      registration = Pulse::Register.new(@saas, @instance_id, @private_key)
      @instance_id ||= registration.instance_id
      @private_key ||= registration.private_key
      @task = Tasker.every(heartbeat_interval) { heartbeat }
    end

    def heartbeat
      Message.new(@instance_id, @private_key).send
    end

  end
end