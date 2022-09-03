require "json"
require "ed25519"
require "./constants"
require "./request"
require "./response"

module PlaceOS::Pulse
  abstract struct Message(T)
    include JSON::Serializable

    getter saas : Bool
    getter instance_id : String
    getter message : T
    getter signature : String

    def initialize(
      @instance_id : String,
      @saas : Bool,
      @message : T,
      private_key : Ed25519::SigningKey
    )
      @signature = private_key.sign(@message.to_json).hexstring
    end

    def self.verify_signature(public_key : String, message : String, signature : String)
      Ed25519::VerifyKey.new(public_key.hexbytes).verify!(signature.hexbytes, message)
    end
  end

  # Generate classes as using the generic Message(T) struct
  {% begin %}
    {% for request in Request.subclasses %}
      struct {{ request.name }}Request < Message({{ request }})
      end
    {% end %}

    {% for response in Response.subclasses %}
      struct {{ request.name }}Response < Message({{ response }})
      end
    {% end %}
  {% end %}
end
