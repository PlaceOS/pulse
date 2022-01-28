require "./base"

module PlaceOS::Pulse
  abstract struct Request < Base
  end
end

require "./request/*"
