require_relative 'base'

module Persistence
  module Repositories
    class Tasks < BaseRepository[:tasks]
      def with_users
        root.combine(:users)
      end
    end
  end
end
