require "./spec_helper"

include Pulse

describe Pulse do
  # test setup method
  it "should setup a placeos instance" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
      .to_return(status: 201, body: "")

    setup = Pulse.setup("gab@place.technology")
    setup.should be_a HTTP::Client::Response
    setup.status_code.should eq 201

    # test setup method with custom somain
    custom_domain_setup = Pulse.setup("gab@place.technology", "https://localhost:3001")
    custom_domain_setup.should be_a HTTP::Client::Response
    custom_domain_setup.status_code.should eq 201
    # is this just testing that the webmock works?
  end

  # test hearbeat method
  it "should create send a heartbeat to client portal" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}")
      .to_return(status: 201, body: "")

    heartbeat = Pulse.heartbeat
    heartbeat.should be_a HTTP::Client::Response
    heartbeat.status_code.should eq 201
  end

  it "should generate a client portal link from environment variables" do
    link = client_portal_link

    link.should be_a String
    link.should eq "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end
end
