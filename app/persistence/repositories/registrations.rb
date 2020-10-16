require 'lib/persistence/repository'

module App
  module Persistence
    module Repositories
      class Registrations < Utils::Persistence::Repository[:registrations]
        def with_clients
          root.combine(:clients)
        end

        def by_date(date)
          root.where(exam_date: date)
        end

        def count_for_date(date)
          root.where(exam_date: date).count
        end
      end
    end
  end
end
