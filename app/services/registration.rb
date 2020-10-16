require 'attr_extras'
require 'dry/monads'
require 'dry/monads/do'

require 'lib/utils'
require 'app/dependencies'

module App
  module Services
    class Registration
      include Import[:config, :db]
      include Dry::Monads[:result]
      include Dry::Monads::Do.for(:perform)

      class ClientAlreadyRegisteredForDate < Failure
        def initialize(client:, date:)
          super({ client: client, date: date })
        end
      end

      class DailyRegistrationLimitReached < Failure
        def initialize(date)
          super({ date: date })
        end
      end

      attr_private_initialize %i[config db data]

      def self.perform(data)
        new(data: data).perform
      end

      def perform
        db.clients.transaction do
          client       = yield create_or_update_client
          registration = yield create_registration(client)

          Success.new({ client: client, registration: registration })
        end
      end

      private

      def create_or_update_client
        client_data = self.data.slice(:first_name, :last_name, :municipality, :zip_code,
                                      :email, :phone_number, :insurance_number, :insurance_company)

        existing = db.clients.lock_by_insurance_number(client_data[:insurance_number])

        client =
          if existing.exist?
            without_ins_num = Utils::Hash.reject_keys(client_data, [:insurance_number])

            existing.command(:update).call(without_ins_num)
          else
            db.clients.create(client_data)
          end

        Success.new(client)
      end

      def create_registration(client)
        registration_data = self.data
          .slice(:requestor_type, :exam_type, :exam_date)
          .merge({ client_id: client.id, registered_at: Time.now })

        # TODO: check registration limits for the day

        exam_date                   = registration_data[:exam_date]
        existing_registration_count = db.registrations.count_for_date(exam_date)
        daily_registration_limit    = config[:daily_registration_limit]

        if existing_registration_count >= daily_registration_limit
          return DailyRegistrationLimitReached.new(exam_date)
        end

        begin
          Success.new(db.registrations.create(registration_data))
        rescue Sequel::UniqueConstraintViolation # FIXME: this is an abstraciton leak
          ClientAlreadyRegisteredForDate.new(client: client, date: registration_data[:exam_date])
        end
      end
    end
  end
end
