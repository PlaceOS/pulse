require "json"
require "sodium"
require "openapi-generator/serializable"

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
      private_key : Sodium::Sign::SecretKey
    )
      @signature = private_key.sign_detached(@message.to_json).hexstring
    end

    def self.verify_signature(public_key : String, message : String, signature : String)
      Sodium::Sign::PublicKey.new(public_key.hexbytes).verify_detached(message, signature.hexbytes)
    end
  end

  # Generate classes as using the generic Message(T) struct directly does not work with
  # elbywan's `openapi-generator`.
  {% begin %}
    {% for request in Request.subclasses %}
      struct {{ request.name }}Request < Message({{ request }})
        extend OpenAPI::Generator::Serializable
      end
    {% end %}

    {% for response in Response.subclasses %}
      struct {{ request.name }}Response < Message({{ response }})
        extend OpenAPI::Generator::Serializable
      end
    {% end %}
  {% end %}
end
