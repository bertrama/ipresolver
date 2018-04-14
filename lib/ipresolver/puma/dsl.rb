module Ipresolver
  module Puma
    module DSL
      def proxies(value)
        @options[:proxies] = value
      end
    end
  end
end
