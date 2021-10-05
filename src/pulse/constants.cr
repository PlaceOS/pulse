module PlaceOS::Pulse
  PLACE_PORTAL_URI = ENV["PLACE_PORTAL_URI"]?.presence || "https://placeos.run"

  JWT_PUBLIC_KEY  = self.required_env("JWT_PUBLIC_KEY")
  JWT_PRIVATE_KEY = self.required_env("JWT_PRIVATE_KEY")

  PULSE_SAAS        = self.boolean_env("PLACE_PULSE_SAAS")
  PULSE_INSTANCE_ID = ENV["PlACE_PULSE_INSTANCE_ID"]?.presence

  def self.required_env(key : String) : String
    ENV[key]?.presence || abort("Expected #{key} in environment")
  end

  def self.boolean_env(key : String) : Bool
    ENV[key]?.presence.try(&.downcase).in?("true", "1")
  end
end
