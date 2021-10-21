require "./request"

module PlaceOS::Pulse
  struct Message::Register < Request
    getter email : String
    getter proof_of_work : String
    getter public_key : String

    # Generate the register request, performing proof-of-work
    #
    def self.generate(email, instance_id)
      new(
        email,
        Hashcash.generate(instance_id),
        public_key
      )
    end

    def initialize(@email, @proof_of_work, @public_key)
    end
  end
end
