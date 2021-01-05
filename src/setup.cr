require "json"

class Pulse::Setup
  include JSON::Serializable

  getter instance_primary_contact : String
  getter instance_domain : String
  getter proof_of_work : String

  def initialize(
    @instance_primary_contact : String,
    @instance_domain : String = "http://localhost:3000"
  )
    @proof_of_work = Hashcash.generate(@instance_primary_contact, bits: 22)
  end

  def send
    HTTP::Client.post client_portal_link + "/setup", body: self.to_json
  end
end
