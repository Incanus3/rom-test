require 'rom/sql'
require_relative 'entities'

Dry::Types.load_extensions(:maybe)

module CommonViews
  def by_id(id)
    where(id: id) #.one!
  end
end

class Users < ROM::Relation[:sql]
  UUID = ROM::SQL::Types::String.default { SecureRandom.uuid }

  schema do
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

class Tasks < ROM::Relation[:sql]
  schema do
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
