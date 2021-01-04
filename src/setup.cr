require "json"

class Setup
  include JSON::Serializable
  property instance_primary_contact : String
  property instance_domain : String
  property proof_of_work : String

  def initialize(
    @instance_primary_contact : String,
    @instance_domain : String # might need a default
  )
    @proof_of_work = Hashcash.generate(@instance_primary_contact, bits: 22)
  end
end
