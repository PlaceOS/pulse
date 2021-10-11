require "placeos-models"
require "promise"

require "./request"

module PlaceOS::Pulse
  struct Message::Heartbeat < Request
    enum Feature
      Desks
      Carparks
      Rooms

      def to_s(io)
        io << to_s
      end

      def to_s
        super.downcase
      end

      def to_json_object_key
        to_json
      end
    end

    getter feature_count : Hash(Feature, Int32)

    getter zone_count : Int32

    getter system_count : Int32

    record ModuleCount, count : Int32, running : Int32 do
      include JSON::Serializable
    end

    getter module_instances : Hash(String, ModuleCount)

    def self.system_count
      PlaceOS::Model::ControlSystem.count
    end

    def self.zone_count
      PlaceOS::Model::Zone.count
    end

    def self.feature_count
      PlaceOS::Model::Metadata.all.each_with_object(Hash(Feature, Int32).new(0)) do |metadata, count|
        # Select for Zone metadata
        next unless metadata.parent_id.try(&.starts_with? PlaceOS::Model::Zone.table_name)
        # Select for valid feature name
        next unless feature = Feature.parse? metadata.name

        if (details = metadata.details.as_a?).nil?
          Log.warn { {
            message: "expected an array, got #{metadata.details}",
            zone_id: metadata.parent_id,
            feature: feature.to_s,
          } }
        else
          count[feature] += details.size
        end
      end
    end

    def self.module_instances
      PlaceOS::Model::Module
        .all
        .each_with_object(Hash(String, Tuple(Int32, Int32)).new { |h, k| h[k] = {0, 0} }) do |mod, tally|
          count, running = tally[mod.name]
          count += 1
          running += 1 if mod.running
          tally[mod.name] = {count, running}
        end.transform_values { |count, running| ModuleCount.new(count, running) }
    end

    def self.from_database
      # telemetry = Promise.all(
      #   Promise.defer { feature_count },
      #   Promise.defer { module_instances },
      #   Promise.defer { zone_count },
      #   Promise.defer { system_count },
      # ).get
      #
      # Heartbeat.new(*telemetry)
      Heartbeat.new(feature_count, module_instances, zone_count, system_count)
    end

    def initialize(
      @feature_count : Hash(Feature, Int32),
      @module_instances : Hash(String, ModuleCount),
      @zone_count : Int32,
      @system_count : Int32
    )
    end
  end
end
