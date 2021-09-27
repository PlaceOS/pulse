require "log"
require "hashcash"
require "sodium"
require "ulid"
require "json"
require "http/client"

require "./constants"

module Pulse
  # Usage: Pulse::Register.new(saas, instance_id?, private_key?)
  # We may not have an instance ID yet and have to generate one on init
  #
  class Register
    getter instance_id : String
    getter private_key : String

    def initialize(@saas : Bool = false, instance_id = nil, private_key = nil)
      # First, generate our credentials if none are passed in
      @instance_id, @private_key = instance_id.nil? ? generate_creds : {instance_id, private_key}
    end

    # Returns an instance ID and generated private key (to be used to generate pubkey when required)
    def generate_creds : Tuple(String, String)
      key = Sodium::Sign::SecretKey.new
      {ULID.generate, key.to_slice.hexstring}
    end

    # Takes our generated credentials and POSTs them to the portal's API
    # Returns the response from the portal side
    def portal_request : Bool
      payload = {
        saas:                @saas,
        instance_id:         @instance_id,
        instance_public_key: public_key,
        proof_of_work:       Hashcash.generate(@instance_id),
      }

      register_response = HTTP::Client.post("#{PORTAL_API_URI}/register", body: payload.to_json)

      # TODO:: Raise a proper error here
      raise("Register Request Failed") if !register_response.status == (HTTP::Status.new(200) || HTTP::Status.new(201))

      # If this is a saas instance then we need to encrypt the JWT_PRIVATE_KEY and send it back, otherwise we're good
      if @saas
        portal_response = NamedTuple(instance_id: String, portal_public_key: String).from_json(register_response.body)
        payload = {
          user_id:     SERVICE_USER_ID,
          private_key: encrypt_jwt_key(portal_response[:portal_public_key]),
        }
        key_response = HTTP::Client.post "#{PORTAL_API_URI}/instances/#{@instance_id}/new_key", HTTP::Headers.new, body: payload.to_json

        if !key_response.status == (HTTP::Status.new(200) || HTTP::Status.new(201))
          # TODO:: Throw some error
        end
      else
        # FIXME: this is unused?
        _portal_response = NamedTuple(instance_id: String).from_json(register_response.body)
      end

      # If we get to here without erroring return true
      true
    end

    # Encrypt this instance's JWT_PRIVATE_KEY using the passed in public key
    def encrypt_jwt_key(portal_public_key : String) : String
      # This is for encryption so use CryptoBox not Sign
      key = Sodium::CryptoBox::PublicKey.new(portal_public_key.hexbytes)
      String.new(key.encrypt(JWT_PRIVATE_KEY))
    end

    def public_key : String
      Sodium::Sign::SecretKey.new(@private_key.hexbytes).public_key.to_slice.hexstring
    end
  end
end
