module Pulse
  PORTAL_URI = URI.parse(ENV["PORTAL_URI"]?.presence || "https://placeos.run")

  PLACE_URI            = self.required_env("PLACE_URI")
  PLACE_EMAIL          = self.required_env("PLACE_EMAIL")
  PLACE_PASSWORD       = self.required_env("PLACE_PASSWORD")
  PLACE_AUTH_CLIENT_ID = self.required_env("PLACE_AUTH_CLIENT_ID")
  PLACE_AUTH_SECRET    = self.required_env("PLACE_AUTH_SECRET")
  PLACE_INSECURE       = ENV["PLACE_INSECURE"]?.presence.try(&.downcase).in?("true", "1")

  # TODO: Default to production Portal API URI
  PORTAL_API_URI = ENV["PORTAL_API_URI"]?.presence || "https://portal-dev.placeos.run"

  # TODO: Confirm where this ID originates from
  SERVICE_USER_ID = ENV["SERVICE_USER_ID"]?.presence || "user-12345"

  def self.required_env(key : String) : String
    ENV[key]?.presence || abort("Expected #{key} in environment")
  end
end
