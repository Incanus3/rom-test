require 'entities'
require 'persistence/utils'

module Persistence
  module Relations
    class Tasks < ROM::Relation[:sql]
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

      struct_namespace Entities
      auto_struct true

      include CommonViews

      def for_users(_assoc, users)
        where(user_id: users.map { |u| u[:id] })
      end
    end
  end
end