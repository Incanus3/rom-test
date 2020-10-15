require 'rom'
require 'lib/env_vars'

module Utils
  module Persistence
    def self.configure(uri = nil, logger: nil, auto_registration: nil, **connect_options)
      ROM::Configuration.new(:sql, uri || "#{connect_options[:adapter]}://", **connect_options) do |config|
        config.gateways[:default].use_logger(logger) if logger

        if auto_registration
          root_dir = auto_registration.delete(:root_dir)
          config.auto_registration(root_dir, **auto_registration)
        end
      end
    end
  end
end
