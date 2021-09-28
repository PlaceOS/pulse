require "json"

require "./constants"
require "./heartbeat"

module Pulse
  class Message
    include JSON::Serializable

    getter instance_id : String

    # TODO: Caspian: not breaking the interface for now, but doesn't make sense to do this rename...
    @[JSON::Field(key: "message")]
    getter contents : Pulse::Heartbeat

    getter signature : String

    @[JSON::Field(ignore: true)]
    getter place_portal_uri : URI

    def initialize(
      @instance_id : String,
      private_key : String,
      @contents : Pulse::Heartbeat = Heartbeat.from_database,
      @place_portal_uri : URI = URI.parse(PLACE_PORTAL_URI)
    )
      # Gab: Private key will be passed in as a string, so init an actual key instance
      key = Sodium::Sign::SecretKey.new(private_key.hexbytes)
      @signature = (key.sign_detached @contents.to_json).hexstring
    end

    # FIXME: IO should be handled by the client itself, not the data.
    def send(custom_uri_path : String? = "") # e.g. /setup
      HTTP::Client.put("#{@place_portal_uri}/instances/#{@instance_id}#{custom_uri_path}", body: to_json)
    end
  end
end
