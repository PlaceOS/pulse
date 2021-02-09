require "json"

class Pulse::Setup
  include JSON::Serializable

  getter instance_primary_contact : String
  getter instance_domain : String
  getter proof_of_work : String
  getter public_key : String

  def initialize(
    @instance_primary_contact : String,
    @instance_domain = "http://localhost:3000"
  )
    @proof_of_work = Hashcash.generate(@instance_primary_contact, bits: 22)
    @public_key = Sodium::Sign::SecretKey.new(App::SECRET_KEY.hexbytes).public_key.to_slice.hexstring
  end
end
