# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DubAskIt
  class Application < Rails::Application
    config.action_dispatch.rescue_responses['Pundit::NotAuthorizedError'] = :forbidden

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/ru.yml
    # Языки, которые буду поддерживаться
    config.i18n.available_locales = %i[en ru]
    # локаль по умолчанию
    config.i18n.default_locale = :en
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # Временная зона приложения
    # config.time_zone = "Central Time (US & Canada)"
    config.time_zone = 'Moscow'
    config.active_record.default_timezone = 'Moscow'
    # config.eager_load_paths << Rails.root.join("extras")

    # ActiveJob должен использовать адаптер Sidekiq
    config.active_job.queue_adapter = :sidekiq

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
