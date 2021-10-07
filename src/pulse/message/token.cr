require "./request"

module PlaceOS::Pulse
  struct Message::Token < Request
    getter token : String

    def initialize(@token)
    end
  end
end
