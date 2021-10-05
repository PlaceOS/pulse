require "json"

abstract struct PlaceOS::Pulse::Request
  include JSON::Serializable
end
