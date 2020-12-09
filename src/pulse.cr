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

  users_email = "gab@place.technology"

  
  def build_json_blob(users_email)
  
  end
  
  json_blob = {

    "proof_of_work": "#{generate_proof_of_work(users_email)}"
  }


  model = PlaceOS::Model::Driver.count

  puts model

  # systems_count = PlaceOS::Model::System.count
  # put systems_count

  zones_count = PlaceOS::Model::Zone.count
  puts zones_count
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
