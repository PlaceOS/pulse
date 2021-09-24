module Pulse
  class Message
    include JSON::Serializable
    getter instance_id : String
    getter contents : Pulse::Heartbeat # revise type, make generic
    getter signature : String
    getter portal_uri : URI

    def initialize(
        @instance_id,
        @private_key : String,
        @contents = Pulse::Heartbeat.new,
        @portal_uri : URI = URI.parse (ENV["PORTAL_URI"] || "http://placeos.run")
    )
        # Private key will be passed in as a string so init an actual key instance
        key = Sodium::Sign::SecretKey.new(@private_key.hexbytes)
        @signature = (key.sign_detached @contents.to_json).hexstring
    end

    def payload
        { instance_id: @instance_id,  message: @contents, signature: @signature }.to_json
    end

    def send(custom_uri_path : String? = "") # e.g. /setup
        HTTP::Client.put "#{@portal_uri}/instances/#{@instance_id}#{custom_uri_path}", body: payload.to_json
    end
  end
end