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

  # TODO document
  def self.setup(email : String, domain = App::INSTANCE_DOMAIN)
    Pulse::Setup.new(email, domain).send
  end

  # TODO document
  def self.heartbeat
    Pulse::Heartbeat.new.send
  end

  # should this be private - or live somewhere else?
  def client_portal_link : String
    "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end
end
