require "hashcash"

require "./request"

module PlaceOS::Pulse
  struct Message::Register < Request
    getter email : String

    getter instance_id : String

    getter proof_of_work : String

    getter public_key : String

    # Generate the register request, performing proof-of-work
    #
    def self.generate(email, instance_id, public_key)
      new(
        email,
        instance_id,
        Hashcash.generate(instance_id),
        public_key
      )
    end

    def valid?(instance_id : String)
      Hashcash.validate!(proof_of_work, instance_id)
      true
    rescue error : Hashcash::Error
      Log.warn(exception: error) { "invalid proof of work" }
      false
    end

    def initialize(@email, @proof_of_work, @public_key)
    end
  end
end
