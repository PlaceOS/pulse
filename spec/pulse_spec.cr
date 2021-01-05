require "./spec_helper"

include Pulse

describe Pulse do
  it "should generate a client portal link from environment variables" do
    link = client_portal_link

    link.should be_a String
    link.should eq "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end

  # test high level setup method
  pending "should setup a placeos instance" do
    # WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
    #   # with(body : setup_json)
    #   .to_return(status: 201, body: "")

    # setup = Pulse.setup("gab@place.technology")
    # # is this actually useful?
    # setup.should be_a HTTP::Client::Response
    # setup.status_code.should eq 201

    # finish this spec
  end

  it "should setup a placeos instance with class method" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup")
      # with(body : setup_json)
      .to_return(status: 201, body: "")

    setup = Pulse::Setup.new("gab@place.technology", "https://localhost:3000").send
    setup.should be_a HTTP::Client::Response
    setup.status_code.should eq 201

    # finish this spec
  end

  it "should send a heartbeat class method" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}")
      # with(body : )
      .to_return(status: 201, body: "")

    heartbeat = Pulse::Heartbeat.new.send
    heartbeat.should be_a HTTP::Client::Response
    heartbeat.status_code.should eq 201
  end

  pending "should setup a placeos instance with a custom domain" do
    # webmock
    # Pulse.setup("gab@place.technology", "customdomain.custom")
    # TODO finish - also maybe merge this with the other webmock spec
  end

  # test send heartbeat
end
