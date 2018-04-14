require 'ipaddr'

module Ipresolver
  class Middleware
    REMOTE_ADDR = 'REMOTE_ADDR'
    X_FORWARDED_FOR = 'HTTP_X_FORWARDED_FOR'
    TRUSTED_PROXIES = [
      '127.0.0.1/16'
    ]

    attr_accessor :app, :proxies

    def initialize(app, proxies: TRUSTED_PROXIES)
      @app = app
      @proxies = [proxies].flatten.map { |proxy| IPAddr.new(proxy) }
    end

    def call(env)
      new_env = env.merge(
        "ipresolver.#{REMOTE_ADDR}" => env[REMOTE_ADDR],
        "ipresplver.#{X_FORWARDED_FOR}" => env[X_FORWARDED_FOR]
      )
      new_env[REMOTE_ADDR] = resolve_ip(new_env)
      new_env.delete(X_FORWARDED_FOR)
      app.call(new_env)
    end

    private

    def resolve_ip(env)
      return env[REMOTE_ADDR] unless env[X_FORWARDED_FOR]
      resolve(parse_ips(env[X_FORWARDED_FOR]) + parse_ips(env[REMOTE_ADDR]))
    end

    def parse_ips(ips)
      return [] unless ips
      ips.strip.split(/[,\s]+/)
    end

    def resolve(ips)
      return nil unless ips
      return ips.last if ips.length <= 1
      return ips.last unless candidate = ipaddr(ips.last)
      return ips.last unless proxies.any? { |proxy| proxy.include?(candidate) }
      resolve(ips.slice(0, ips.length - 1))
    end

    def ipaddr(ip)
      IPAddr.new(ip)
    rescue
      nil
    end
  end
end
