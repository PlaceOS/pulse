require "./spec_helper"

include Pulse

describe Pulse do
  describe ".setup" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
      .to_return(status: 201, body: "")

    it "with default args" do
      setup = Pulse.setup("gab@place.technology")
      setup.should be_a HTTP::Client::Response
      setup.status_code.should eq 201
    end

    it "with custom domain" do
      custom_domain_setup = Pulse.setup("gab@place.technology", "https://localhost:3001")
      custom_domain_setup.should be_a HTTP::Client::Response
      custom_domain_setup.status_code.should eq 201
    end
    it "should" do
      setup = Pulse.setup("gab@place.technology")
    end
  
  end

  it ".heartbeat" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}")
      .to_return(status: 201, body: "")

    heartbeat = Pulse.heartbeat
    heartbeat.should be_a HTTP::Client::Response
    heartbeat.status_code.should eq 201
  end

  # it "#client_portal_link" do
  #   link = client_portal_link

  #   link.should be_a String
  #   link.should eq "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  # end

  # describe "#sign" do
  #   it "setup object" do
  #     setup_object = Pulse::Setup.new("gab@place.technology")
  #     sign(setup_object).should be_a NamedTuple(heartbeat: JSON::Any, signature: String)
  #   end

  #   it "heartbeat object" do
  #     heartbeat = Pulse::Heartbeat.new
  #     sign(heartbeat).should be_a NamedTuple(heartbeat: JSON::Any, signature: String)
  #   end
  # end

end

describe Pulse::Message do
  it "#sign" do
    heartbeat = Pulse::Heartbeat.new
    pp! message = Pulse::Message.new(heartbeat)
    
    message.signature.should be_a String
    message.signature.size.should eq 128
    message.message.should be_a Pulse::Heartbeat
    
    #.instance_id.should eq "01EY2J7MQYABT40TVYAK7JPMCK"
    
    pp! recieved = JSON.parse(message.payload)

    SECRET_KEY.public_key.verify_detached(recieved["message"].to_s, recieved["signature"].to_s.hexbytes).should be_nil
  end
end
