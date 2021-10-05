require "./request"

module PlaceOS::Pulse
  struct Token < Request
    getter token : String

    def initialize(@token)
    end
  end
end
