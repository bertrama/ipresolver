require 'puma/plugin'
require 'ipresolver'
require 'ipresolver/puma/dsl'

Puma::Plugin.create do
  Puma::DSL.include(Ipresolver::Puma::DSL)

  def start(launcher)
    app = launcher.config.options[:app] || launcher.config.instance_eval { load_rackup }
    proxies = launcher.config.options[:proxies] || Ipresolver::Middleware::TRUSTED_PROXIES
    launcher.config.options[:app] = Ipresolver::Middleware.new(app, proxies: proxies)
  end
end
