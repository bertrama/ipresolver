# Ipresolver

## Problem Statement

`Rack::Request` and `ActiveDispatch::Request` make assumptions about networks and expectations that are not true where I work.

These assumptions are:
* Connections from [private network](https://en.wikipedia.org/wiki/Private_network) addresses can be trusted when they provide an X-Forwarded-For header.
    * Unless ALL of the IP addresses in an X-Forwarded-For header come from a [private network](https://en.wikipedia.org/wiki/Private_network)

## Considerations from the real world

* It is common for academic institutions to license access to publishers' content.
* In these arrangements, access control to licensed content is typically based on the IP address of the client.
* The academic institutions frequently employ a forwarding proxy server to allow their affiliates access to the publisher's content when using personal devices.
* Affiliates' personal account credentials are regularly attacked and compromised in an attempt for an attacker to gain access to institution's forwarding proxy server.
* If the forwarding proxy server provides an X-Forwarded-For header, the publisher could use that to better detect attacks designed to exfiltrate their content.
* Academic institutions sometimes use private network IP addresses internally.
* Publishers often employ reverse proxies.

### Scenarios

I make a distinction between a forward proxy and a reverse proxy here that isn't very meaningful in the context of a single client communicating with a single server.

It's probably better to indicate trusted status vs. untrusted status. But I've already drawn a bunch of boxes in ascii.


```
1. Client talks directly to Rack.
+------+      +----+
|Client| +--> |Rack|
+------+      +----+


2. Client talks to a forward proxy which talks directly to Rack .
                                 Trust
+------+      +-------------+      +      +----+
|Client| +--> |Forward Proxy| +--> | +--> |Rack|
+------+      +-------------+      +      +----+


3. Client talks to a reverse proxy which talks directly to Rack.
            Trust
+------+      +      +-------------+      +----+
|Client| +--> | +--> |Reverse Proxy| +--> |Rack|
+------+      +      +-------------+      +----+


4. Client talks to a forward proxy which talks to a reverse proxy which talks to Rack.
                                 Trust
+------+      +-------------+      +      +-------------+      +----+
|Client| +--> |Forward Proxy| +--> | +--> |Reverse Proxy| +--> |Rack|
+------+      +-------------+      +      +-------------+      +----+


5. Client talks to 0 ... N forward proxies which talks to 0 ... N reverse proxies before talkling to Rack.
                                           Trust
+------+      +-----------------------+      +      +-----------------------+      +----+
|Client| +--> |0 ... N Forward Proxies| +--> | +--> |0 ... N Reverse Proxies| +--> |Rack|
+------+      +-----------------------+      +      +-----------------------+      +----+
```

## What about spoofing?

Spoofing, i.e. when a client sends an X-Forwarded-For header can happen.  But the Rack application won't use that IP address.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ipresolver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ipresolver

## Usage

It's Rack middleware
```ruby

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bertrama/ipresolver.
