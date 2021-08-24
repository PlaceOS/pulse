require "hashcash"
require "sodium"
require "ulid"
require "json"
require "http/client"

module Pulse

  #
  # Usage: Pulse::Register.new(saas, instance_id?, private_key?)
  # We may not have an instance ID yet and have to generate one on init
  #
  class Register
    
    PORTAL_API_URI  = ENV["PORTAL_API_URI"]
    SERVICE_USER_ID = ENV["SERVICE_USER_ID"]

    getter instance_id : String?
    getter private_key : String?

    def initialize(@saas : Bool = false, @instance_id=nil, @private_key=nil)
      @instance_id, @private_key = generate_creds if @instance_id.nil?
    end

    # Returns an instance ID and generated private key (to be used to generate pubkey when required)
    def generate_creds : Tuple(String, String)
      key = Sodium::Sign::SecretKey.new
      { ULID.generate, key.to_slice.hexstring }
    end
    
    # Takes our generated credentials and POSTs them to the portal's API
    # Returns the response from the portal side
    def portal_request : Pulse::PortalResponse
      payload = {
        saas: @saas,
        instance_id: @instance_id,
        instance_public_key: public_key,
        proof_of_work: Hashcash.generate(@instance_id || "")
      }
      register_response = HTTP::Client.post "#{PORTAL_API_URI}/register", HTTP::Headers.new, body: payload
      
      if register_response.status.accepted?
        # If this is a saas instance then the portal will respond with a public key used to encrypt the JWT_PRIVATE_KEY
        portal_response = @saas ? NamedTuple(instance_id: String, portal_public_key: String).from_json(register_response.body) : NamedTuple(instance_id: String).from_json(register_response.body)
      else
        # TODO:: Throw some error here as something has gone wrong
      end

      # If this is a saas instance then we need to encrypt the JWT_PRIVATE_KEY and send it back, otherwise we're good
      if @saas
        payload = {
          user_id: SERVICE_USER_ID,
          private_key: encrypt_jwt_key(portal_response[:portal_public_key])
        }
        key_response = HTTP::Client.post "#{PORTAL_API_URI}/instances/#{@instance_id}/new_key", HTTP::Headers.new, body: payload

        if !key_response.accepted?
          # TODO:: Throw some error 
        end
      end

      # Regardless of whether this is a saas instance we want to return the portal response now
      portal_response[:instance_id]
    end

    # Encrypt this instance's JWT_PRIVATE_KEY using the passed in public key
    def encrypt_jwt_key(portal_public_key : String) : String
      # This is for encryption so use CryptoBox not Sign
      key = Sodium::CryptoBox::PublicKey.new(portal_public_key.hexbytes)
      String.new(key.encrypt(ENV['JWT_PRIVATE_KEY']))
    end

    def public_key : String
      Sodium::Sign::SecretKey.new((@private_key || "").hexbytes).public_key.to_slice.hexstring
    end

  end
end