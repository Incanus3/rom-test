require 'dry/system/container'
require 'lib/env_vars'

module App
  class Dependencies < Dry::System::Container
    DEFAULT_DB_OPTIONS = {
      adapter:       ENV.fetch('DB_BACKEND',  'postgres'),
      host:          ENV.fetch('DB_HOST',     'localhost'),
      port:          ENV.fetch('DB_PORT',     '5432'),
      user:          ENV.fetch('DB_USER',     'rom_test'),
      password:      ENV.fetch('DB_PASSWORD', 'rom_test'),
      database:      ENV.fetch('DB_NAME',     'rom_test'),
    }.freeze

    ENV_TO_OUTPUT_PROVIDER = {
      production:  -> { File.open(File.join(APP_ROOT, 'log', 'central.log'), 'a') },
      development: -> { $stderr },
      test:        -> { IO::NULL },
    }.freeze

    # TODO: split logging into several files in production
    def self.logger
      env     = resolve(:env) or raise 'env must be registered before calling logger'
      verbose = Utils::EnvVars.fetch_bool(:verbose)

      Logger.new(ENV_TO_OUTPUT_PROVIDER[env].call, level: verbose ? :debug : :info)
    end

    env = ENV.fetch('APP_ENV', :development).to_sym

    register :env,    env
    register :logger, logger

    boot(:persistence) do |container|
      init do
        require 'lib/persistence/configuration'
        require 'app/persistence/container'

        options = DEFAULT_DB_OPTIONS.merge({
          logger:        container[:logger],
          sql_log_level: :debug,
        })
        options[:database] += '_test' if container[:env] == :test

        container.register(:db, App::Persistence::Container.new(options))
      end

      # start do
      #   container[:db].connect
      # end

      stop do
        container[:db].disconnect
      end
    end
  end

  Import = Dry::AutoInject(Dependencies)
end
