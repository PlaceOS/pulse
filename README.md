# pulse

PlaceOS heartbeat manager

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     pulse:
       github: placeos/pulse
   ```

2. Run `shards install`

## Usage

```crystal
require "pulse"
```

```crystal
# The instance needs to the URI of the portal to register with
export PORTAL_URI=https://portal-dev.placeos.run
```

```crystal

# Create a new Pulse client which registers this instance with the PlaceOS Portal and creates a heartbeat running once a day
pulse_client = Pulse::Client.new
pulse_client.registered
# => true

# If this is not a SaaS instance we can pass in `false` as the first param and the instance's private key won't be shared with the portal
pulse_client = Pulse::Client.new(false)
pulse_client.saas
# => false

# If an instance ID and corresponding private key already exist they can be passed in
instance_id = ULID.generate
private_key = Sodium::Sign::SecretKey.new.to_slice.hexstring
pulse_client = Pulse::Client.new(false, instance_id, private_key)
pulse_client.instance_id == instance_id
# => true

# The frequency which an instance sends heartbeats can be defined with the heartbeat_interval param
pulse_client = Pulse::Client.new(heartbeat_interval: 1.hour)
```

Initialising the client will create an automated task which POSTs to `<PORTAL_URI>/instances/<INSTANCE_ID>/heartbeat` with the frequency defined by the `heartbeat_interval` param which defaults to one per day.

## Development

TODO: Write development instructions here

`crystal spec` to run tests

## Contributing

1. Fork it (<https://github.com/your-github-user/pulse/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Gab Fitzgerald](https://github.com/GabFitzgerald) - creator and maintainer
