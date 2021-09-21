require "json"
# require "rest-api"

class Pulse::Heartbeat
  include JSON::Serializable

  getter desks_qty : Int32
  getter carparks_qty : Int32
  getter rooms_qty : Int32
  # add any other telemetry to collect here in future

  def initialize
    client = PlaceOS::Client.new(
      base_uri: ENV["PLACE_URI"],
      email: ENV["PLACE_EMAIL"],
      password: ENV["PLACE_PASSWORD"],
      client_id: ENV["PLACE_AUTH_CLIENT_ID"],
      client_secret: ENV["PLACE_AUTH_SECRET"],
      insecure: ENV["PLACE_INSECURE"] || true
    )
    @desks_qty = count_features(client, "desks")
    @carparks_qty = count_features(client, "desks")
    @rooms_qty = client.systems.search.size
  end

  def count_features(client : PlaceOS::Client, metadata_name : String) : Int32
    # First get all the zones
    zones = client.zones.search
    # Now store all the desk objects in any of these zones
    features = [] of JSON::Any
    zones.each do |z|
      feature_metadata = client.metadata.fetch(z.id, metadata_name)
      features += feature_metadata[metadata_name].details.as_a unless feature_metadata.empty? || !feature_metadata[metadata_name]
    end
    # Finally, pass back the total count of desks
    features.size
  end
end
