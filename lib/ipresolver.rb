require "ipresolver/version"
require 'ipaddr'

class Ipresolver
  TRUSTED_PROXY = [
    '127.0.0.1/16'
  ]

  attr_accessor :app, :proxies

  def initialize(app, proxies = TRUSTED_PROXY)
    @app = app
    @proxies = proxies.map { |proxy| IPAddr.new(proxy) }
  end

  def call(env)
    env['ipresolver.REMOTE_ADDR'] = env['REMOTE_ADDR']
    env['ipresplver.HTTP_X_FORWARDED_FOR'] = env['HTTP_X_FORWARDED_FOR']
    env['REMOTE_ADDR'] = resolve_ip(env)
    env.delete('HTTP_X_FORWARDED_FOR')
    app.call(env)
  end

  private

  def resolve_ip(env)
    return env['REMOTE_ADDR'] unless env['HTTP_X_FORWARDED_FOR']
    resolve(parse_ips(env['HTTP_X_FORWARDED_FOR']) + parse_ips(env['REMOTE_ADDR']))
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
