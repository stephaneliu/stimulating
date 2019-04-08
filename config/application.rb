require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stimulating
  class Application < Rails::Application
      config.generators do |g|
        g.helper              false
        g.test_framework      :rspec, fixture: true
        g.view_specs          false
        g.fixture_replacement :factory_bot, dir: "spec/factories"
        g.helper              false
        g.template_engine     :haml
        g.stylesheet_engine   :sass
        g.javascript_engine   :coffee
      end
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
