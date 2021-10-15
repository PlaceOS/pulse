require "../spec_helper"
ROUTE_BASE          = "/api/portal/v1/"
MOCK_INSTANCE_ID    = "mock-id"
MOCK_INSTANCE_EMAIL = "test@place.tech"

module PlaceOS::Pulse
  describe Message do
    it "should contain a signature which can be verified with the public key" do
      backend = ::Log::IOBackend.new(STDOUT)
      ::Log.setup { |c| c.bind("*", :info, backend) }
      # Generate the data that would usually be passed in
      private_key_obj = Sodium::Sign::SecretKey.new
      register_message = Message::Register.generate(
        email: MOCK_INSTANCE_EMAIL,
        instance_id: MOCK_INSTANCE_ID
      )
      message = Message.new(MOCK_INSTANCE_ID, true, register_message, private_key_obj)

      message.signature.should eq (private_key_obj.sign_detached register_message.to_json).hexstring
    end

    it "has a class method that verifies the message signature" do
      # Generate a message and signature to verify
      private_key_obj = Sodium::Sign::SecretKey.new
      register_message = Message::Register.generate(
        email: MOCK_INSTANCE_EMAIL,
        instance_id: MOCK_INSTANCE_ID
      )
      message = Message.new(MOCK_INSTANCE_ID, true, register_message, private_key_obj)

      PlaceOS::Pulse::Message.verify_signature(private_key_obj.public_key.to_slice.hexstring, register_message.to_json, message.signature).should eq nil
    end
  end
end
