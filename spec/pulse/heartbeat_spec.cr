require "placeos-models"

require "../spec_helper"
require "../../lib/placeos-models/spec/generator"

module PlaceOS::Pulse
  describe Heartbeat do
    before_all do
      Model::ControlSystem.clear
      Model::Metadata.clear
      Model::Module.clear
      Model::Zone.clear

      # Initialize mocks
      control_systems
      modules
      zones
      metadata
    end

    it ".system_count" do
      Heartbeat.system_count.should eq control_systems.size
    end

    it ".zone_count" do
      Heartbeat.zone_count.should eq zones.size
    end

    it ".feature_count" do
      Heartbeat.feature_count.should eq feature_count
    end

    it ".module_instances" do
      Heartbeat.module_instances.should eq module_instances
    end
  end
end
