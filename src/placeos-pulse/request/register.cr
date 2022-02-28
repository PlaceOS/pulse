require "hashcash"

require "../request"

module PlaceOS::Pulse
  struct Register < Request
    getter domain : String
    getter name : String
    getter email : String

    getter proof_of_work : String

    getter public_key : String

    # Generate the register request, performing proof-of-work
    #
    def self.generate(domain, name, email, instance_id, public_key)
      new(
        domain,
        name,
        email,
        Hashcash.generate(instance_id),
        public_key
      )
    end

    def valid?(instance_id : String)
      Hashcash.valid!(proof_of_work, instance_id)
      true
    rescue error : Hashcash::Error
      Log.warn(exception: error) { "invalid proof of work" }
      false
    end

    def initialize(@email, @proof_of_work, @public_key)
    end
  end
end
