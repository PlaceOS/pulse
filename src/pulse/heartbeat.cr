require "json"
require "placeos-models/zone"
require "placeos-models/metadata"

class Pulse::Heartbeat
  include JSON::Serializable

  enum Feature
    Desks
    Carparks
    Rooms
  end

  getter counts : Hash(Feature, Int32)

  def self.from_database
    feature_count = Models::Metadata.all.each_with_object(Hash(Feature, Int32).new(0)) do |metadata, count|
      # Select for Zone metadata
      next unless metadata.parent_id.starts_with? Zone.table_name
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

    Heartbeat.new(feature_count)
  end

  def self.from_client
    client = PlaceOS::Client.new(
      base_uri: PLACE_URI,
      email: PLACE_EMAIL,
      password: PLACE_PASSWORD,
      client_id: PLACE_AUTH_CLIENT_ID,
      client_secret: PLACE_AUTH_SECRET,
      insecure: PLACE_INSECURE
    )

    count = Hash(Feature, Int32).new(0)

    # Fetch _ALL_ Zones
    client.zones.search.each do |zone|
      # Extract metadata for desired feature
      client.metadata.fetch(zone.id).each do |metadata_name, details|
        # Select for valid feature name
        next unless feature = Feature.parse?(metadata_name)

        if (feature_array = details.as_a?).nil?
          Log.warn { {
            message: "expected an array, got #{details}",
            zone_id: zone.id,
            feature: feature.to_s,
          } }
        else
          count[feature] += feature_array.size
        end
      end
    end

    Heartbeat.new(count)
  end

  def initialize(@counts : Hash(Feature, Int32))
  end
end
