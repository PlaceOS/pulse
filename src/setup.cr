require "json"

class Pulse::Setup
  include JSON::Serializable

  # should these be getters??
  property instance_primary_contact : String
  property instance_domain : String
  property proof_of_work : String

  def initialize(
    @instance_primary_contact : String,
    @instance_domain : String # might need a default
  )
    @proof_of_work = Hashcash.generate(@instance_primary_contact, bits: 22)
  end

  def send
    HTTP::Client.post client_portal_link + "/setup", body: self.to_json
  end
end
