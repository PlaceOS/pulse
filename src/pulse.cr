require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"

module Pulse
  CLIENT_PORTAL_URI = "http://127.0.0.1:3000"

  

  
  def build_json_blob(users_email)
  
  end
  
  
  

  def self.send_heartbeat
    drivers_count = PlaceOS::Model::Driver.count
    zones_count = PlaceOS::Model::Zone.count
    users_count = PlaceOS::Model::User.count
    # modules = PlaceOS::Model::Module.elastic

    heartbeat_json = {
      "instance_id" => "put_instance_id_here???",
      "drivers_qty" => drivers_count,
      "zones_qty" => zones_count,
      "users_qty" => users_count
    }.to_json

    HTTP::Client.post "#{CLIENT_PORTAL_URI}/instances", body: heartbeat_json
  end

  def self.setup
    puts "enter you email to connect with PlaceOS Client Portal"
    users_email = gets || ""

    instance_id = "01ERJXRPCQ844Y1PPQPBVBR4B6"
 
    json_blob = {
      "instance_domain" => "https://localhost:3000", 
      "instance_primary_contact" => "#{users_email}",
      "proof_of_work": "#{generate_proof_of_work(users_email)}"
    }.to_json

    
    HTTP::Client.post "#{CLIENT_PORTAL_URI}/instances/#{instance_id}/setup", body: json_blob
  end
  # puts setup.response
  # puts model
  # capture user email??
  # capture instance domain
  # client2 = PlaceOS::Client::API::Models

  # post started up to client portal 




  # post heartbeat to portal

# get zones - count the number

  # schedule tasks 



  # cli ui - does that belong here??

  # generate proof of work
  private def generate_proof_of_work(resource)
    Hashcash.generate(resource)
  end


end

include Pulse

Pulse.send_heartbeat

