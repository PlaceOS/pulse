require "../spec_helper"

module PlaceOS::Pulse
  describe Message do
    describe "#signature" do
      it "returns a signature of the message's contents" do
        message.signature.should eq private_key.sign(register_message.to_json).hexstring
      end
    end

    describe ".verify_signature" do
      it "verifies the message signature" do
        PlaceOS::Pulse::Message.verify_signature(private_key.verify_key.to_slice.hexstring, register_message.to_json, message.signature).should be_nil
      end
    end
  end
end
