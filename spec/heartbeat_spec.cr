require "./spec_helper"

describe Pulse::Heartbeat do
  it ".new" do
    heartbeat = Pulse::Heartbeat.new

    heartbeat.instance_type.should eq "production"
    heartbeat.instance_id.should eq App::PLACEOS_INSTANCE_ID
    heartbeat.staff_api.should eq true
    heartbeat.drivers_qty.should be_a Int32
    heartbeat.users_qty.should be_a Int32
    heartbeat.zones_qty.should be_a Int32
  end

  it ".send" do
    WebMock.stub(:post, "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}")
      .to_return(status: 201, body: "")

    heartbeat = Pulse::Heartbeat.new.send
    heartbeat.should be_a HTTP::Client::Response
    heartbeat.status_code.should eq 201
  end

  it ".sign" do
    # pp! secret_key = Sodium::Sign::SecretKey.new
  end
end
