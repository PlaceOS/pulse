require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "./constants"

require "./setup_body"

module Pulse
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
      "staff_api"   => staff_api.to_s,

      # find instance_type
      # find staff_api
      # find analytics

      "instance_type" => "production",
    }.to_json

    puts heartbeat_json
    HTTP::Client.post "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}", body: heartbeat_json
  end

  def self.setup(users_email : String, instance_domain = "https://localhost:3000")
    # makes post request to placeos client portal to setup instance
    HTTP::Client.post setup_link, body: setup_json(instance_domain, users_email)
  end

  # post started up to client portal

  # post heartbeat to portal

  # get zones - count the number

  # schedule tasks

  private def setup_link : String
    "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}/setup"
  end

  # make this a SetupBody class method?
  private def setup_json(instance_domain : String, users_email : String)
    SetupBody.new(users_email, generate_proof_of_work(users_email), instance_domain).to_json
  end

  private def generate_proof_of_work(resource) : String
    Hashcash.generate(resource, bits: 22)
  end
end

# include Pulse

# Pulse.setup
