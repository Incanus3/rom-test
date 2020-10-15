require 'rom'

module Utils
  module Persistence
    def self.configure(...)
      ROM::Configuration.new(:sql, 'sqlite::memory') do |config|
        config.auto_registration(...)
      end
    end
  end
end
