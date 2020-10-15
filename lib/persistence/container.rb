module Utils
  module Persistence
    class Container
      DEFAULT_REPO_OPTIONS = {}

      def self.new(config)
        super(ROM.container(config))
      end

      def initialize(rom_container)
        @repositories  = {}
        @rom_container = rom_container
      end

      def gateways
        self.rom_container.gateways
      end

      private

      attr_reader :rom_container

      def create_repo(cls)
        @repositories[cls.name] ||= cls.new(self.rom_container, **self.class::DEFAULT_REPO_OPTIONS)
      end
    end
  end
end
