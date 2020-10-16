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
          by_date(date).count
        end

        def sql_for_export
          registrations
            .join(clients)
            .select(registrations[:registered_at], registrations[:requestor_type],
                    registrations[:exam_type],     registrations[:exam_date],
                    clients[:last_name],           clients[:first_name],
                    clients[:insurance_number],    clients[:insurance_company],
                    clients[:zip_code],            clients[:municipality],
                    clients[:phone_number],        clients[:email])
            .dataset
            .sql
        end
      end
    end
  end
end
