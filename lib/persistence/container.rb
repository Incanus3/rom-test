require_relative 'config'
require_relative 'repositories'

module Persistence
  class Container
    def self.new(config = Persistence.configure)
      super(ROM.container(config))
    end

    def initialize(rom_container)
      @rom_container = rom_container
    end

    def gateways
      self.rom_container.gateways
    end

    def users
      @_users_repo ||= Persistence::Repositories::Users.new(self.rom_container)
    end

    def tasks
      @_tasks_repo ||= Persistence::Repositories::Tasks.new(self.rom_container)
    end

    private

    attr_reader :rom_container
  end
end
