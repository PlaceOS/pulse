require "./spec_helper"
require "ulid"
require "sodium"

module Pulse
  describe Client do
    it "creates new credentials and registers (without saas) when initialised without credentials" do
      WebMock.stub(:post, "#{PORTAL_API_URI}/register")
        .to_return(body: {instance_id: ""}.to_json)
      pulse = Pulse::Client.new
      pulse.registered.should eq true
      pulse.instance_id.should_not be_nil
      pulse.private_key.should_not be_nil
    end

    it "uses existing credentials and registers when initialised with input" do
      new_id = ULID.generate
      new_key = Sodium::Sign::SecretKey.new.to_slice.hexstring
      WebMock.stub(:post, "#{PORTAL_API_URI}/register")
        .to_return(body: {instance_id: new_id}.to_json)
      pulse = Pulse::Client.new(false, new_id, new_key)
      pulse.registered.should eq true
      pulse.instance_id.should eq new_id
      pulse.private_key.should eq new_key
    end

    it "does the saas key flow and uses existing credentials and registers when initialised with input" do
      # Generate our credentials to pass in
      new_id = ULID.generate
      new_key = Sodium::Sign::SecretKey.new
      # Stub not just register but the portal endpoint for key exchange
      WebMock.stub(:post, "#{PORTAL_API_URI}/register")
        .to_return(body: {instance_id: new_id, portal_public_key: new_key.public_key.to_slice.hexstring}.to_json)
      WebMock.stub(:post, "#{PORTAL_API_URI}/instances/#{new_id}/new_key")
        .to_return(body: {instance_id: new_id}.to_json)

      # Now we can actually create the registration
      pulse = Pulse::Client.new(true, new_id, new_key.to_slice.hexstring)
      pulse.instance_id.should eq(new_id)
      pulse.private_key.should eq(new_key.to_slice.hexstring)
    end
  end

  # # We can reenable this once we work out how to stub rethinkdb
  # describe Pulse::Heartbeat do
  #   it "provides counts when initialised" do

  #     WebMock.stub(:get, "http://localhost:28015")
  #     .to_return(body: "{}")
  #     heartbeat = Pulse::Heartbeat.new
  #     heartbeat.drivers_qty.should eq 0
  #     heartbeat.zones_qty.should eq 0
  #     heartbeat.users_qty.should eq 0
  #   end
  # end

  #   it ".heartbeat" do
  #     WebMock.stub(:post, "http://placeos.run/instances/01EY4PBEN5F999VQKP55V4C3WD")
  #       .to_return(status: 201, body: "")

  #     pulse = Pulse.new("01EY4PBEN5F999VQKP55V4C3WD", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb")
  #     heartbeat = pulse.heartbeat
  #     heartbeat.should be_a HTTP::Client::Response
  #     heartbeat.status_code.should eq 201
  #   end
  # end

  # describe Message do
  #   it ".new" do
  #     secret = Sodium::Sign::SecretKey.new("b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb".hexbytes)
  #     message = Message.new("01EY4PBEN5F999VQKP55V4C3WD", secret)
  #     message.instance_id.should eq "01EY4PBEN5F999VQKP55V4C3WD"
  #     message.portal_uri.should eq URI.parse "http://placeos.run"
  #     message.signature.should eq "7c51c1bf33cec94259a53f6a5d72420af6d83be0dc16824cf0739df1c844c6c3554597f8ca8739e018bd31c1ba4652215572fcd7ac33ea6d72c0167bd7ab1b0f"

  #     secret.public_key.verify_detached(message.contents.to_json, message.signature.hexbytes).should be_nil
  #   end

  #   it ".payload" do
  #     secret = Sodium::Sign::SecretKey.new("b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb".hexbytes)
  #     message = Message.new("01EY4PBEN5F999VQKP55V4C3WD", secret)
  #     message.payload.should eq "{\"instance_id\":\"01EY4PBEN5F999VQKP55V4C3WD\",\"contents\":{\"drivers_qty\":0,\"zones_qty\":0,\"users_qty\":0,\"staff_api\":true,\"instance_type\":\"PROD\"},\"signature\":\"7c51c1bf33cec94259a53f6a5d72420af6d83be0dc16824cf0739df1c844c6c3554597f8ca8739e018bd31c1ba4652215572fcd7ac33ea6d72c0167bd7ab1b0f\"}"
  #   end

  #   it ".send" do
  #     secret = Sodium::Sign::SecretKey.new("b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb".hexbytes)
  #     WebMock.stub(:post, "http://placeos.run/instances/01EY4PBEN5F999VQKP55V4C3WD")
  #       .to_return(status: 201, body: "")

  #     # heartbeat = Pulse::Heartbeat.new
  #     Pulse::Heartbeat.new
  #     message = Message.new("01EY4PBEN5F999VQKP55V4C3WD", secret)
  #     response = message.send
  #     response.should be_a HTTP::Client::Response
  #     response.status_code.should eq 201
  # end
end
