require_relative 'base'

module Persistence
  module Repositories
    class Users < BaseRepository[:users]
      def with_tasks
        root.combine(:tasks)
      end

      def by_name(name)
        root.by_name(name).one!
      end
    end
  end
end
