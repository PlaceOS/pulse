require "./spec_helper"

describe Pulse::Heartbeat do
  # test initialise

  # test send
  it "should send a heartbeat class method" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}")
      # with(body : )
      .to_return(status: 201, body: "")

    heartbeat = Pulse::Heartbeat.new.send
    heartbeat.should be_a HTTP::Client::Response
    heartbeat.status_code.should eq 201
  end


end
