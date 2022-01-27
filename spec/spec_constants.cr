module PlaceOS::Pulse
  MOCK_INSTANCE_ID    = "mock-id"
  MOCK_INSTANCE_TOKEN = "mock-token"
  MOCK_INSTANCE_EMAIL = "test@place.tech"
  MOCK_PRIVATE_KEY    = "bfbd56cbd0a1e48f5766f7544b70223a7a613bb79ad0a9ef0e025f50ac7b84ab8f99e6c6e974a30389721aa4edf64ce2123dfcf741e24c50c4ccab7d89cde709"
  API_BASE            = "#{PLACE_PORTAL_URI}/api/portal/v1"
  ROUTE_BASE          = "/api/portal/v1/"

  class_getter private_key : Sodium::Sign::SecretKey do
    Sodium::Sign::SecretKey.new(MOCK_PRIVATE_KEY.hexbytes)
  end

  class_getter register_message : Message::Register do
    Message::Register.generate(
      email: MOCK_INSTANCE_EMAIL,
      instance_id: MOCK_INSTANCE_ID,
      public_key: private_key.public_key.to_slice.hexstring
    )
  end

  class_getter message : Message do
    Message.new(MOCK_INSTANCE_ID, true, register_message, private_key)
  end

  class_getter control_systems : Array(PlaceOS::Model::ControlSystem) do
    Array.new(3) do
      Model::Generator.control_system.save!
    end
  end

  class_getter zones : Array(PlaceOS::Model::Zone) do
    Array.new(2) do
      Model::Generator.zone.save!
    end
  end

  class_getter modules : Array(PlaceOS::Model::Module) do
    module_instances.flat_map do |name, total|
      driver = Model::Generator.driver(module_name: name, role: :device).save!
      mods = Array.new(total.count) do
        mod = Model::Generator.module(driver: driver)
        mod.running = false
        mod
      end

      mods[0...total.running].each do |mod|
        mod.running = true
      end

      mods.tap &.each(&.save!)
    end
  end

  class_getter module_instances : Hash(String, Message::Heartbeat::ModuleCount) do
    # Mock diverse module data
    {
      "Special" => {2, 1},
      "Printer" => {1, 0},
      "TV"      => {4, 3},
    }.transform_values { |count, running| Message::Heartbeat::ModuleCount.new(count, running) }
  end

  class_getter metadata : Array(PlaceOS::Model::Metadata) do
    parent_zone = zones.first
    feature_count.map do |feature, count|
      meta = Model::Generator.metadata(parent: parent_zone)
      meta.name = feature.to_s
      meta.details = JSON::Any.new(Array.new(count) { JSON::Any.new(feature.to_s) })
      meta.save!
    end
  end

  class_getter feature_count : Hash(Message::Heartbeat::Feature, Int32) do
    Message::Heartbeat::Feature.values.map_with_index do |feature, index|
      {feature, index}
    end.to_h
  end
end
