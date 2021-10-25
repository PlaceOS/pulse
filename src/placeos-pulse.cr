require "./placeos-pulse/*"

module PlaceOS::Pulse
  def self.from_environment(token : String? = nil) : Client
    Client.new(
      instance_token: token,
      email: instance_email,
      instance_id: instance_id,
      saas: saas?
    )
  end
end
