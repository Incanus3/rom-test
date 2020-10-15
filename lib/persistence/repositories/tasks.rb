require_relative 'base'

module Persistence
  class TasksRepository < BaseRepository[:tasks]
    def with_users
      root.combine(:users)
    end
  end
end
