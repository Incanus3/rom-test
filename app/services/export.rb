require 'English'
require 'dry/monads'

module App
  module Services
    class Export
      include Import[:db]
      include Dry::Monads[:result]

      static_facade :perform, [:db]

      def perform
        select_sql   = db.registrations.sql_for_export
        psql_command = "\\copy (#{select_sql}) to STDOUT CSV DELIMITER ';' HEADER FORCE QUOTE *"
        db_options   = db.gateways[:default].options
        command      = ("PGPASSWORD=#{db_options[:password]} psql "         \
                        "-h #{db_options[:host]} -p #{db_options[:port]} "  \
                        "-U #{db_options[:user]} #{db_options[:database]} " \
                        "-c \"#{psql_command}\"")

        output = `set -o pipefail; #{command} | tail -n +2`

        $CHILD_STATUS.success? ? Success(output) : Failure(output)
      end
    end
  end
end
