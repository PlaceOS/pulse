require "json"

struct PlaceOS::Pulse::Message::Register
  include JSON::Serializable

  getter public_key : String
  getter proof_of_work : String

  # Generate the register request, performing proof-of-work
  #
  def self.generate(public_key, instance_id)
    new(
      public_key,
      Hashcash.generate(instance_id)
    )
  end

  def initialize(@public_key, @proof_of_work)
  end
end
