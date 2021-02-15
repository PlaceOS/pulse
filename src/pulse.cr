require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "tasker"
require "sodium"

class Pulse
  getter instance_id : String
  getter secret_key : String
  getter task : Tasker::Repeat(HTTP::Client::Response) # not sure about the correct type here.

  def initialize(
    @instance_id : String,
    @secret_key : String,
    heartbeat_interval : Time::Span = 1.day
  )
    @task = Tasker.every(heartbeat_interval) { heartbeat }
  end

  def heartbeat
    Message.new(@instance_id, @secret_key.hexbytes).send
  end

  def finalize
    @task.cancel
  end
end

class Message < Pulse
  include JSON::Serializable
  getter instance_id : String
  getter message : Pulse::Heartbeat # rename to payload
  getter signature : String
  getter portal_uri : String

  def initialize(
    @instance_id : String,
    secret_key : Bytes,
    @message = Pulse::Heartbeat.new,
    @portal_uri : String = "http://placeos.run"
  )
    @signature = (Sodium::Sign::SecretKey.new(secret_key).sign_detached @message.to_json).hexstring
  end

  def payload
    {instance_id: @instance_id, message: @message, signature: @signature}.to_json
  end

  def send(custom_uri : String? = "") # e.g. /setup
    HTTP::Client.post "#{@portal_uri}/instances/#{@instance_id}#{custom_uri}", body: payload.to_json
  end
end

require "./helpers/*"
