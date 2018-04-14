# frozen_string_literal: true

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
