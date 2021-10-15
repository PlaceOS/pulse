require "../spec_helper"
ROUTE_BASE          = "/api/portal/v1/"
MOCK_INSTANCE_ID    = "mock-id"
MOCK_INSTANCE_EMAIL = "test@place.tech"

module PlaceOS::Pulse
  class_getter private_key_obj : Sodium::Sign::SecretKey do
    Sodium::Sign::SecretKey.new
  end

  class_getter register_message : PlaceOS::Pulse::Message::Register do
    Message::Register.generate(
      email: MOCK_INSTANCE_EMAIL,
      instance_id: MOCK_INSTANCE_ID
    )
  end

  class_getter message : PlaceOS::Pulse::Message do
    Message.new(MOCK_INSTANCE_ID, true, register_message, private_key_obj)
  end

  describe Message do
    it "should contain a signature which can be verified with the public key" do
      message.signature.should eq (private_key_obj.sign_detached register_message.to_json).hexstring
    end

    it "has a class method that verifies the message signature" do
      PlaceOS::Pulse::Message.verify_signature(private_key_obj.public_key.to_slice.hexstring, register_message.to_json, message.signature).should eq nil
    end
  end
end
