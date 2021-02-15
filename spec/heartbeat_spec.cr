require "./spec_helper"

describe Pulse::Heartbeat do
  it ".new" do
    heartbeat = Pulse::Heartbeat.new

    heartbeat.instance_type.should eq "production"
    heartbeat.staff_api.should eq true
  end
end
