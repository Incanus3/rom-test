require 'entities'
require 'persistence/utils'

Dry::Types.load_extensions(:maybe)

module Persistence
  module Relations
    class Users < ROM::Relation[:sql]
      UUID = ROM::SQL::Types::String.default { SecureRandom.uuid }

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

      struct_namespace Entities
      auto_struct true

      include CommonViews

      def listing
        select(:id, :name, :email).order(:name)
      end
    end
  end
end
