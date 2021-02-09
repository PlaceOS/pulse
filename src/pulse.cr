require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "tasker"
require "./constants"

require "./helpers/setup"
require "./helpers/heartbeat"

Tasker.cron("30 7 * * *") { Pulse.heartbeat }

module Pulse
  # TODO document
  def self.setup(email : String, domain = App::INSTANCE_DOMAIN)
    HTTP::Client.post client_portal_link + "/setup", body: sign(Pulse::Setup.new(email, domain)).to_json
  end

  # TODO document
  def self.heartbeat
    HTTP::Client.post "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}", body: Pulse::Heartbeat.new.sign.to_json
  end

  def client_portal_link : String
    "#{App::CLIENT_PORTAL_URI}/instances/#{App::PLACEOS_INSTANCE_ID}"
  end

  def sign(object : Pulse::Setup | Pulse::Heartbeat) : {heartbeat: JSON::Any, signature: String}
    sig = Sodium::Sign::SecretKey.new(App::SECRET_KEY.hexbytes).sign_detached object.to_json
    {heartbeat: JSON.parse(object.to_json), signature: sig.hexstring}
  end
end
