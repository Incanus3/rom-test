require 'lib/persistence/configuration'
require 'lib/persistence/container'

require 'app/entities'

require_relative 'repositories/users'
require_relative 'repositories/tasks'

module App
  module Persistence
    class Container < Utils::Persistence::Container
      DEFAULT_REPO_OPTIONS = { auto_struct: true, struct_namespace: App::Entities }.freeze

      def self.new
        super(Utils::Persistence.configure(__dir__, namespace: 'App::Persistence'))
      end

      def users
        create_repo(Persistence::Repositories::Users)
      end

      def tasks
        create_repo(Persistence::Repositories::Tasks)
      end
    end
  end
end
