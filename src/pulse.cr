require "./pulse/*"

module PlaceOS::Pulse
  def self.from_environment : Client
    Client.new(
      saas: saas?,
      instance_id: instance_id,
    )
  end
end
