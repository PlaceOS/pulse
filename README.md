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
include Pulse
Pulse.setup(users_email, instance_domain)
```

explain the setup method here

explain the heartbeat method here


TODO: Write usage instructions here

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
