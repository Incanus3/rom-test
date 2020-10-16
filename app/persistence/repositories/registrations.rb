require 'lib/persistence/repository'

module App
  module Persistence
    module Repositories
      class Registrations < Utils::Persistence::Repository[:registrations]
        def with_clients
          root.combine(:clients)
        end
      end
    end
  end
end
