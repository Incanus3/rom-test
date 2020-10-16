require 'lib/persistence/relation'

module App
  module Persistence
    module Relations
      class Registrations < Utils::Persistence::Relation
        schema(:registrations) do
          attribute :id,             Types::Integer
          attribute :client_id,      Types::ForeignKey(:clients)
          # TODO: fill this in using command mappers
          attribute :registered_at,  Types::DateTime
          # TODO: map these to enum types
          attribute :requestor_type, Types::String
          attribute :exam_type,      Types::String
          attribute :exam_date,      Types::Date

          primary_key :id

          associations do
            belongs_to :client
          end
        end
      end
    end
  end
end
