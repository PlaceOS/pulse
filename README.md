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

# Create a new Pulse client which registers this instance with the PlaceOS Portal and creates a heartbeat running once a day
pulse_client = Pulse::Client.new
pulse_client.registered
# => true

# If this is a SaaS instance we can pass in `true` as the first param and the instance's private key will be shared with the portal to allow SaaS workflows
pulse_client = Pulse::Client.new(true)
pulse_client.saas
# => true

# If an instance ID and corresponding private key already exist they can be passed in
instance_id = ULID.generate
private_key = Sodium::Sign::SecretKey.new.to_slice.hexstring
pulse_client = Pulse::Client.new(false, instance_id, private_key)
pulse_client.instance_id == instance_id
# => true
```

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
