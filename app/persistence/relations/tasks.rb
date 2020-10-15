require 'lib/persistence/relation'

module App
  module Persistence
    module Relations
      class Tasks < Utils::Persistence::Relation
        schema(:tasks) do
          attribute :id, Types::Integer
          attribute :user_id, Types::ForeignKey(:users)
          # defaults to `Types::Int` but can be overridden:
          # attribute :user_id, Types::ForeignKey(:users, Types::UUID)
          attribute :title, Types::String

          primary_key :id

          associations do
            belongs_to :user
          end
        end

        def for_users(_assoc, users)
          where(user_id: users.map { |u| u[:id] })
        end
      end
    end
  end
end
