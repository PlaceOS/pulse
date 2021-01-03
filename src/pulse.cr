require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "./constants"

module Pulse
  CLIENT_PORTAL_URI = "http://127.0.0.1:3000"

  def build_json_blob(users_email)
  end

  def self.send_heartbeat

    # find instance_id
    drivers_count = PlaceOS::Model::Driver.count
    zones_count = PlaceOS::Model::Zone.count
    users_count = PlaceOS::Model::User.count
    staff_api = PlaceOS::Model::Repository.exists?("staff_api") # this is a guess idk if it works
    # modules = PlaceOS::Model::Module.elastic

    heartbeat_json = {
      # find instance_id
      "instance_id" => "#{App::PLACEOS_INSTANCE_ID}",
      "drivers_qty" => drivers_count.to_s,
      "zones_qty"   => zones_count.to_s,
      "users_qty"   => users_count.to_s,
      "staff_api" => staff_api.to_s,

      # find instance_type
      # find staff_api
      # find analytics

      "instance_type" => "production"
    }.to_json

    puts heartbeat_json 
    HTTP::Client.post "#{CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}", body: heartbeat_json
  end

  def self.setup
    puts "Enter you email to connect with PlaceOS Client Portal"
    users_email = gets || ""

    # TODO instance_id will not be generated here - or in Pulse service at all
    # store as env var??
    instance_id = ULID.generate

    json_blob = {
      "instance_domain"          => "https://localhost:3000",
      "instance_primary_contact" => "#{users_email}",
      "proof_of_work":              "#{generate_proof_of_work(users_email)}",
    }.to_json

    HTTP::Client.post "#{CLIENT_PORTAL_URI}/instances/#{instance_id}/setup", body: json_blob
  end

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

Pulse.setup
# puts generate_proof_of_work("gab@place.technology")
