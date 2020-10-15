require 'dry/monads'
require 'dry/types'
require 'lib/persistence/relation'

Dry::Types.load_extensions(:maybe)

module App
  module Persistence
    module Relations
      class Users < Utils::Persistence::Relation
        UUID = Types::String.default { SecureRandom.uuid }

        schema(:users) do
          # attribute :id,   UUID
          attribute :id,   Types::Integer
          attribute :age,  Types::Integer
          attribute :name, Types::String
          # save bd as string, but when reading, parse it as date
          attribute :birthday, Types::String, read: Types::JSON::Date.maybe

          primary_key :id

          associations do
            has_many :tasks
          end
        end

        def listing
          select(:id, :name, :email).order(:name)
        end

        def by_name(name)
          where(name: name)
        end
      end
    end
  end
end
