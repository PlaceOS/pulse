require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "./constants"

require "./helpers/setup"
require "./helpers/heartbeat"

module Pulse
  # TODO schedule tasks

  # high level setup method
  def setup
    Pulse::Setup.new(email, domain).send
  end

  #

  # high level heartbeat method
  # Pulse::Heartbeat.new.send

  def client_portal_link : String
    "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end
end
