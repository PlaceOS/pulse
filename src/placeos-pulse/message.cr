require "json"
require "sodium"

require "./constants"
require "./message/request"

module PlaceOS::Pulse
  struct Message
    include JSON::Serializable

    getter saas : Bool
    getter instance_id : String
    getter message : Request

    def initialize(
      @instance_id : String,
      @saas : Bool,
      @message : Request
    )
    end
  end
end

require "./message/*"
