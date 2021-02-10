require "./spec_helper"

describe Pulse do
  it ".new" do
    pulse = Pulse.new("01EY4PBEN5F999VQKP55V4C3WD", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb")
    pulse.instance_id.should eq "01EY4PBEN5F999VQKP55V4C3WD"
    pulse.secret_key.should eq "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb"
  end

  describe ".setup" do
    WebMock.stub(:post, "http://placeos.run/instances/01EY4PBEN5F999VQKP55V4C3WD/setup")
      .to_return(status: 201, body: "")

    it "with default args" do
      pulse = Pulse.new("01EY4PBEN5F999VQKP55V4C3WD", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb")
      setup = pulse.setup("gab@place.technology")
      setup.should be_a HTTP::Client::Response
      setup.status_code.should eq 201
    end

    it "with custom domain" do
      pulse = Pulse.new("01EY4PBEN5F999VQKP55V4C3WD", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb")
      custom_domain_setup = pulse.setup("gab@place.technology", "https://localhost:3001")
      custom_domain_setup.should be_a HTTP::Client::Response
      custom_domain_setup.status_code.should eq 201
    end
  end

  it ".heartbeat" do
    WebMock.stub(:post, "http://placeos.run/instances/01EY4PBEN5F999VQKP55V4C3WD")
      .to_return(status: 201, body: "")

    pulse = Pulse.new("01EY4PBEN5F999VQKP55V4C3WD", "b18e1d0045995ec3d010c387ccfeb984d783af8fbb0f40fa7db126d889f6dadd77f48b59caeda77751ed138b0ec667ff50f8768c25d48309a8f386a2bad187fb")
    heartbeat = pulse.heartbeat
    heartbeat.should be_a HTTP::Client::Response
    heartbeat.status_code.should eq 201
  end
end

# describe Pulse::Message do
#   it "#sign" do
#     heartbeat = Pulse::Heartbeat.new
#     message = Pulse::Message.new(heartbeat)

#     message.signature.should be_a String
#     message.signature.size.should eq 128
#     message.message.should be_a Pulse::Heartbeat

#     # .instance_id.should eq "01EY2J7MQYABT40TVYAK7JPMCK"

#     recieved = JSON.parse(message.payload)

#     App::SECRET_KEY.public_key.verify_detached(recieved["message"].to_s, recieved["signature"].to_s.hexbytes).should be_nil
#   end

#   it ".send" do

# WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}")
#     .to_return(status: 201, body: "")
#     heartbeat = Pulse::Heartbeat.new
#     response = Pulse::Sender.send(heartbeat.to_json)
#     response.should be_a HTTP::Client::Response
#     response.status_code.should eq 201
#   end
# end

# describe Pulse::Sender do
#
# end
