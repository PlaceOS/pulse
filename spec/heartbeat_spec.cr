require "./spec_helper"

describe Pulse::Heartbeat do
  it ".new" do
    heartbeat = Pulse::Heartbeat.new

    heartbeat.instance_type.should eq "production"
    heartbeat.staff_api.should eq true
    heartbeat.drivers_qty.should be_a Int32
    heartbeat.users_qty.should be_a Int32
    heartbeat.zones_qty.should be_a Int32
  end
end
