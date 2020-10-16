require 'lib/persistence/relation'

module App
  module Persistence
    module Relations
      class Clients < Utils::Persistence::Relation
        schema(:clients) do
          attribute :id,                Types::Integer
          attribute :first_name,        Types::String
          attribute :last_name,         Types::String
          # TODO: wrap these
          attribute :municipality,      Types::String
          attribute :zip_code,          Types::String
          attribute :email,             Types::String
          attribute :phone_number,      Types::String
          # TODO: wrap these
          attribute :insurance_number,  Types::String
          attribute :insurance_company, Types::Integer

          primary_key :id

          associations do
            has_many :registrations
          end
        end

        def by_name(first:, last:)
          where(first_name: first, last_name: last)
        end
      end
    end
  end
end
