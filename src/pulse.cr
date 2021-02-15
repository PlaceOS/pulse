require "placeos-models"
require "ulid"
require "hashcash"
require "placeos"
require "rethinkdb-orm"
require "http/client"
require "tasker"
require "sodium"

class Pulse
  private getter instance_id : String
  private getter secret_key : Sodium::Sign::SecretKey
  private getter task : Tasker::Repeat(HTTP::Client::Response)

  def initialize(
    @instance_id : String,
    secret_key : String,
    heartbeat_interval : Time::Span = 1.day
  )
    @secret_key = Sodium::Sign::SecretKey.new(secret_key.hexbytes)
    @task = Tasker.every(heartbeat_interval) { heartbeat }
  end

  def heartbeat
    Message.new(@instance_id, @secret_key).send
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
    secret_key : Sodium::Sign::SecretKey,
    @message = Pulse::Heartbeat.new,
    @portal_uri : String = "http://placeos.run"
  )
    @signature = (secret_key.sign_detached @message.to_json).hexstring
  end

  def payload
    {instance_id: @instance_id, message: @message, signature: @signature}.to_json
  end

  def send(custom_uri : String? = "") # e.g. /setup
    HTTP::Client.post "#{@portal_uri}/instances/#{@instance_id}#{custom_uri}", body: payload.to_json
  end
end

require "./helpers/*"
