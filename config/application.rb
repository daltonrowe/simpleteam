require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SimpleTeam
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "UTC"
    # config.eager_load_paths << Rails.root.join("extras")

    extra_paths = %W[
      #{config.root}/lib
    ]

    # Add generators, they don't have a module structure that matches their directory structure.
    extra_paths += Dir.glob("#{config.root}/lib/generators/*")
    extra_paths += Dir.glob("#{config.root}/test/mailers/*")

    config.autoload_paths += extra_paths
    config.eager_load_paths += extra_paths
  end
end
