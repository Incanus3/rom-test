require 'lib/persistence/repository'

module App
  module Persistence
    module Repositories
      class Tasks < Utils::Persistence::Repository[:tasks]
        def with_users
          root.combine(:users)
        end
      end
    end
  end
end
