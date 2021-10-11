require "placeos-models"

require "../spec_helper"
require "../../lib/placeos-models/spec/generator"

module PlaceOS::Pulse
  class_getter control_systems : Array(PlaceOS::Model::ControlSystem) do
    Array.new(3) do
      Model::Generator.control_system.save!
    end
  end

  class_getter zones : Array(PlaceOS::Model::Zone) do
    Array.new(2) do
      Model::Generator.zone.save!
    end
  end

  class_getter modules : Array(PlaceOS::Model::Module) do
    module_instances.flat_map do |name, total|
      driver = Model::Generator.driver(module_name: name).save!
      mods = Array.new(total.count) do
        mod = Model::Generator.module(driver: driver)
        mod.running = false
        mod
      end

      mods[0...total.running].each do |mod|
        mod.running = true
      end

      mods.tap &.each(&.save!)
    end
  end

  class_getter module_instances : Hash(String, Message::Heartbeat::ModuleCount) do
    # Mock diverse module data
    {
      "Special" => {2, 1},
      "Printer" => {1, 0},
      "TV"      => {4, 3},
    }.transform_values { |count, running| Message::Heartbeat::ModuleCount.new(count, running) }
  end

  class_getter metadata : Array(PlaceOS::Model::Metadata) do
    parent_zone = zones.first
    feature_count.map do |feature, count|
      meta = Model::Generator.metadata(parent: parent_zone)
      meta.name = feature.to_s
      meta.details = JSON::Any.new(Array.new(count) { JSON::Any.new(feature.to_s) })
      meta.save!
    end
  end

  class_getter feature_count : Hash(Message::Heartbeat::Feature, Int32) do
    Message::Heartbeat::Feature.values.map_with_index do |feature, index|
      {feature, index}
    end.to_h
  end

  describe Message::Heartbeat do
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
      Message::Heartbeat.system_count.should eq control_systems.size
    end

    it ".zone_count" do
      Message::Heartbeat.zone_count.should eq zones.size
    end

    it ".feature_count" do
      Message::Heartbeat.feature_count.should eq feature_count
    end

    it ".module_instances" do
      Message::Heartbeat.module_instances.should eq module_instances
    end
  end
end
