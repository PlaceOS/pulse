require "json"

class Pulse::Heartbeat
  include JSON::Serializable

  getter instance_id : String
  getter drivers_qty : Int32
  getter zones_qty : Int32
  getter users_qty : Int32
  getter staff_api : Bool
  getter instance_type : String # maybe an enum?
  # add any other telemetry to collect here in future

  def initialize
    @instance_id = "#{App::PLACEOS_INSTANCE_ID}"
    @drivers_qty = PlaceOS::Model::Driver.count
    @zones_qty = PlaceOS::Model::Zone.count
    @users_qty = PlaceOS::Model::User.count
    @staff_api = true             # figure out how to find this
    @instance_type = "production" # and this # maybe an envar...
    # add any other telemetry to collect here in future
  end

  def send
    HTTP::Client.post client_portal_link, body: self.to_json
  end
end
