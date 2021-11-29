require "json"
require "sodium"

require "./constants"

module PlaceOS::Pulse
  struct Message(T)
    include JSON::Serializable

    getter saas : Bool
    getter instance_id : String
    getter message : T
    getter signature : String

    def initialize(
      @instance_id : String,
      @saas : Bool,
      @message : T,
      private_key : Sodium::Sign::SecretKey
    )
      @signature = private_key.sign_detached(@message.to_json).hexstring
    end

    def self.verify_signature(public_key : String, message : String, signature : String)
      Sodium::Sign::PublicKey.new(public_key.hexbytes).verify_detached(message, signature.hexbytes)
    end
  end
end

require "./message/*"
