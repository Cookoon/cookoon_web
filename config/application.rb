require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
require "attachinary/orm/active_record"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CookoonWeb
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'app.forestadmin.com'
        resource '*', headers: :any, methods: :any,
          expose: ['Content-Disposition'],
          credentials: true
      end
    end

    config.time_zone = 'Europe/Paris'
    config.i18n.default_locale = :fr
    config.i18n.available_locales = [:fr]

    config.action_mailer.default_options = {
      from: '"Concierge Cookoon" <concierge@cookoon.fr>'
    }
    config.to_prepare do
      Devise::Mailer.send(:include, Roadie::Rails::Automatic)
      Devise::Mailer.layout 'mailer'
    end

    config.komponent.root = Rails.root.join('app/frontend')
    config.komponent.stylesheet_engine = :scss

    Jbuilder.key_format camelize: :lower

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |g|
      g.komponent stimulus: false, locale: false
      g.test_framework :rspec,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false
    end
  end
end
