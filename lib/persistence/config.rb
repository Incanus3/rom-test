require 'rom'

module Persistence
  def self.configure
    ROM::Configuration.new(:sql, 'sqlite::memory') do |config|
      config.auto_registration(File.join(__dir__))
    end
  end
end
