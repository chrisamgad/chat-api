require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ChatApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))
    config.active_job.queue_adapter = :sneakers
    # config.cache_store = :redis_store, "redis://localhost:6379/0/cache", { expires_in: 90.minutes }
    # config.cache_store = :redis_store, {
    #   expires_in: 1.hour,
    #   namespace: 'cache',
    #   redis: { host: 'localhost', port: 6379, db: 0 },
    #   }
    # config.cache_store = :redis_cache_store, { url: "redis://localhost:6379/0/cache" }

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.web_console.whiny_requests = false
  end
end
