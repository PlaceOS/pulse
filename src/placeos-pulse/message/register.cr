require "./request"

module PlaceOS::Pulse
  struct Message::Register < Request
    getter email : String
    getter proof_of_work : String

    # Generate the register request, performing proof-of-work
    #
    def self.generate(email, instance_id)
      new(
        email,
        Hashcash.generate(instance_id)
      )
    end

    def initialize(@email, @proof_of_work)
    end
  end
end
