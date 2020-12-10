require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"

module Pulse
  # generate proof of work
  def generate_proof_of_work(resource)
    Hashcash.generate(resource)
  end

  puts "enter you email to connect with PlaceOS Client Portal"
  users_email = gets || ""

  
  def build_json_blob(users_email)
  
  end
  
  

  drivers_count = PlaceOS::Model::Driver.count

  # systems_count = PlaceOS::Model::System.count
  # put systems_count

  zones_count = PlaceOS::Model::Zone.count

  users_count = PlaceOS::Model::User.count

  # systems = PlaceOS::Model::System
  # puts systems

  modules = PlaceOS::Model::Module.elastic
  puts modules


  json_blob = {
    "instance_id" => "put_instance_id_here???",
    "instance_primary_contact" => "#{users_email}",
    "proof_of_work": "#{generate_proof_of_work(users_email)}"
  }.to_json

  puts json_blob

  heartbeat_json = {
    "instance_id" => "put_instance_id_here???",
    "drivers_qty" => drivers_count,
    "zones_qty" => zones_count,
    "users_qty" => users_count
  }.to_json

  puts heartbeat_json

  # puts model
  # capture user email??
  # capture instance domain
  # client2 = PlaceOS::Client::API::Models

  # post started up to client portal 


  # post heartbeat to portal

# get zones - count the number

  # schedule tasks 



  # cli ui - does that belong here??


end

include Pulse
# instance = Pulse::Instance.new("ulid", "stamp_string")
# puts instance.generate_ulid
# puts generate_proof_of_work("my_email")
# puts generate_proof_of_work("my_email")
