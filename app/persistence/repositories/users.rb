require 'lib/persistence/repository'

module App
  module Persistence
    module Repositories
      class Users < Utils::Persistence::Repository[:users]
        def with_tasks
          root.combine(:tasks)
        end

        def by_name(name)
          root.by_name(name).one!
        end
      end
    end
  end
end
