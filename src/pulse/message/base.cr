require "json"

# :nodoc:
abstract struct PlaceOS::Pulse::Base
  include JSON::Serializable
end
