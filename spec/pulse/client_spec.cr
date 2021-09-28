require "../spec_helper"

module PlaceOS::Pulse
  describe Client do
    it "creates new credentials and registers (without saas) when initialised without credentials" do
      WebMock.stub(:post, "#{PLACE_PORTAL_URI}/register")
        .to_return(body: {instance_id: ""}.to_json)
      pulse = PlaceOS::Pulse::Client.new
      pulse.registered.should eq true
      pulse.instance_id.should_not be_nil
      pulse.private_key.should_not be_nil
    end

    it "uses existing credentials and registers when initialised with input" do
      new_id = ULID.generate
      new_key = Sodium::Sign::SecretKey.new.to_slice.hexstring
      WebMock.stub(:post, "#{PLACE_PORTAL_URI}/register")
        .to_return(body: {instance_id: new_id}.to_json)
      pulse = PlaceOS::Pulse::Client.new(false, new_id, new_key)
      pulse.registered.should eq true
      pulse.instance_id.should eq new_id
      pulse.private_key.should eq new_key
    end

    it "does the saas key flow and uses existing credentials and registers when initialised with input" do
      # Generate our credentials to pass in
      new_id = ULID.generate
      new_key = Sodium::Sign::SecretKey.new
      # Stub not just register but the portal endpoint for key exchange
      WebMock.stub(:post, "#{PLACE_PORTAL_URI}/register")
        .to_return(body: {instance_id: new_id, portal_public_key: new_key.public_key.to_slice.hexstring}.to_json)
      WebMock.stub(:post, "#{PLACE_PORTAL_URI}/instances/#{new_id}/new_key")
        .to_return(body: {instance_id: new_id}.to_json)

      # Now we can actually create the registration
      pulse = PlaceOS::Pulse::Client.new(true, new_id, new_key.to_slice.hexstring)
      pulse.instance_id.should eq(new_id)
      pulse.private_key.should eq(new_key.to_slice.hexstring)
    end

    pending ".heartbeat" do
      WebMock.stub(:post, "http://placeos.run/instances/01EY4PBEN5F999VQKP55V4C3WD")
        .to_return(status: 201, body: "")

      pulse = PlaceOS::Pulse.new("01EY4PBEN5F999VQKP55V4C3WD", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb")
      heartbeat = pulse.heartbeat
      heartbeat.should be_a HTTP::Client::Response
      heartbeat.status_code.should eq 201
    end
  end
end
