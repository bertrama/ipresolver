# frozen_string_literal: true

module Ipresolver
  module Puma
    # Module for updating the Puma config DSL
    module DSL
      def proxies(value)
        @options[:proxies] = value
      end
    end
  end
end
