require 'lib/persistence/repository'

module App
  module Persistence
    module Repositories
      class Clients < Utils::Persistence::Repository[:clients]
        def with_registrations
          root.combine(:registrations)
        end

        def by_name(...)
          root.by_name(...).first
        end

        def lock_by_insurance_number(number)
          root.where(insurance_number: number).lock
        end
      end
    end
  end
end
