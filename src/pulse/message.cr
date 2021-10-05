require "json"
require "sodium"

require "./constants"
require "./message/request"

module PlaceOS::Pulse
  struct Message
    include JSON::Serializable

    getter saas : Bool
    getter instance_id : String
    getter signature : String
    getter message : Request

    def self.sign(value : Request, key : String)
      value.to_json
      signer = Sodium::Sign::SecretKey.new(key.hexbytes)
      (signer.sign_detached value.to_json).hexstring
    end

    def initialize(
      @instance_id : String,
      @saas : Bool,
      @message : T,
      @key : String = Consants::JWT_PRIVATE_KEY
    )
      @signature = Message.sign(@message, key)
    end
  end
end

require "./message/*"
