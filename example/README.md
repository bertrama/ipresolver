# Examples

## Basic usage in Rack

```ruby
# config.ru

require 'ipresolver'

use Ipresolver::Middleware

run App
```

## Using the Puma plugin

```ruby
# config/puma.rb
require 'ipresolver/puma'

plugin :ipresolver
```

## Systematic injection

## Assumptions

1. You run puma apps out of systemd with ExecStart using something like `bundle exec puma -C config/puma.rb`.
1. 'ipresolver' is installed for the system ruby, but isn't in the bundled gems.

Steps:

1. `gem install ipresolver` # Install ipresolver in the global gems.
1. Create a [global puma configuration](global.rb): 

    ```ruby
    # Fetch Ipresolver from the global gem installation.
    Bundler.with_clean_env do
      ipresolver = Gem.path.map { |path| Dir.glob(path + '/**/ipresolver.gemspec') }.flatten.first
      Gem::Specification.load(ipresolver).activate
      require 'ipresolver/puma'
    end

    # Activate the plugin
    plugin :ipresolver

    # Optionally set your trusted proxies
    proxies '192.168.0.1'

    ```
1. Change the ExecStart to `bundle exec puma -C /etc/puma/global.rb -C config/puma.rb`
