module PlaceOS::Pulse
  PLACE_PORTAL_URI = ENV["PLACE_PORTAL_URI"]?.presence || "https://placeos.run"
  PULSE_SAAS       = self.boolean_env("PLACE_PULSE_SAAS")

  class_getter instance_email : String do
    required_env("PULSE_INSTANCE_EMAIL")
  end

  class_getter instance_id : String do
    required_env("PULSE_INSTANCE_ID")
  end

  class_getter? saas : Bool do
    PULSE_SAAS
  end

  def self.required_env(key : String) : String
    ENV[key]?.presence || abort("Expected #{key} in environment")
  end

  def self.boolean_env(key : String) : Bool
    ENV[key]?.presence.try(&.downcase).in?("true", "1")
  end
end
