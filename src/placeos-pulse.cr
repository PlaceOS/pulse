require "./placeos-pulse/*"

require "placeos-models/base/jwt"

module PlaceOS::Pulse
  def self.from_environment(token : String? = nil) : Client
    Client.new(
      instance_token: token,
      private_key: instance_telemetry_key,
      email: instance_email,
      instance_id: instance_id,
      saas: saas?
    )
  end
end
