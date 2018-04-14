# frozen_string_literal: true

require "bundler/setup"
require "ipresolver"

# This is for Rack::Request
require 'rack'

# These are required for ActionDispatch::Request
require 'active_support/concern'
require 'active_support/core_ext/object/blank'
require 'action_dispatch/middleware/remote_ip'
require 'action_dispatch/http/mime_type'
require 'action_dispatch/http/content_security_policy'
require 'action_dispatch/http/request'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
