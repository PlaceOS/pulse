require "json"

class Heartbeat
  include JSON::Serializable
  property instance_id : String
  property drivers_qty : Int32
  property zones_qty : Int32
  property users_qty : Int32
  property staff_api : Bool
  property instance_type : String # maybe an enum?

  def initialize
    @instance_id = "#{App::PLACEOS_INSTANCE_ID}"
    @drivers_qty = PlaceOS::Model::Driver.count
    @zones_qty = PlaceOS::Model::Zone.count
    @users_qty = PlaceOS::Model::User.count
    @staff_api = true             # figure out how to find this
    @instance_type = "production" # and this # maybe an envar...
  end
end
