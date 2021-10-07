require "../spec_helper"

require "placeos-models/module"
require "../../lib/placeos-models/spec/generator"

module PlaceOS::Pulse
  class_getter modules : Hash(String, Message::Heartbeat::ModuleCount) do
    # Mock diverse module data
    mock_modules = {
      "Special" => {2, 1},
      "Printer" => {1, 0},
      "TV"      => {4, 3},
    }.transform_values { |count, running| Message::Heartbeat::ModuleCount.new(count, running) }

    mock_modules.tap &.each do |name, total|
      driver = Model::Generator.driver(module_name: name).save!
      mods = Array.new(total.count) do
        mod = Model::Generator.module(driver: driver)
        mod.running = false
        mod
      end

      mods[0...total.running].each do |mod|
        mod.running = true
      end

      mods.each &.save!
    end
  end

  describe Message::Heartbeat do
    before_all do
      # Initialize mocks
      Model::Module.clear
      modules
    end

    pending "#feature_count" do
    end

    it "#module_instances" do
      Message::Heartbeat.module_instances.should eq modules
    end
  end
end
