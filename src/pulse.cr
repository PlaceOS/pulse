require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "./constants"

require "./setup"
require "./heartbeat"

module Pulse
  # TODO schedule tasks

  # high level setup method
  # Pulse::Setup.new(email, domain).send

  # high level heartbeat method
  # Pulse::Heartbeat.new.send

  def client_portal_link : String
    "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end

  # # ref send method from classes??
  # private def post_to_client_portal(link : String, body)
  #   # maybe add key/secret encoding here
  #   HTTP::Client.post link, body: body
  # end
end
