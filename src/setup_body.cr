require "json"

class SetupBody
  include JSON::Serializable
  property instance_primary_contact
  property proof_of_work
  property instance_domain

  def initialize(
    @instance_primary_contact : String,
    @proof_of_work : String,
    @instance_domain : String # might need a default
  )
  end
end

# TODO create a request_body class with is inherited by setupbody and heartbeatbody
