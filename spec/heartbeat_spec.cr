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
    heartbeat = Pulse::Heartbeat.new

    hash = {heartbeat: {"instance_id" => "01EXZYPZQRJZGGVGFA7YXM3QCT",
                        "drivers_qty" => 0,
                        "zones_qty" => 0,
                        "users_qty" => 0,
                        "staff_api" => true,
                        "instance_type" => "production"},
    signature: "9d26ae4cff78f753aa3e89ed01791d10275db4a1c5238d2331a3ee3982ad373089cd367f04d6921a3083927fe668697b123362c195b7075e821c3fed09f90508"}

    pp! signed_heartbeat = heartbeat.sign
    signed_heartbeat.should eq hash
  end
end
