require "./pulse/*"

module PlaceOS::Pulse
  def self.from_environment : Client
    Client.new(
      saas: PULSE_SAAS,
      instance_id: PULSE_INSTANCE_ID,
      private_key: PULSE_PRIVATE_KEY,
    )
  end
end
