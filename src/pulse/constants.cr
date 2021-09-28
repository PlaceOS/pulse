module PlaceOS::Pulse
  PLACE_PORTAL_URI = ENV["PLACE_PORTAL_URI"]?.presence || "https://placeos.run"

  JWT_PRIVATE_KEY = self.required_env("JWT_PRIVATE_KEY")

  PULSE_SAAS        = self.boolean_env("PLACE_PULSE_SAAS")
  PULSE_INSTANCE_ID = ENV["PlACE_PULSE_INSTANCE_ID"]?.presence
  PULSE_PRIVATE_KEY = ENV["PlACE_PULSE_PRIVATE_KEY"]?.presence

  # TODO: Confirm where this ID originates from
  SERVICE_USER_ID = ENV["PLACE_SERVICE_USER_ID"]?.presence || "user-12345"

  def self.required_env(key : String) : String
    ENV[key]?.presence || abort("Expected #{key} in environment")
  end

  def self.boolean_env(key : String) : Bool
    ENV[key]?.presence.try(&.downcase).in?("true", "1")
  end
end
