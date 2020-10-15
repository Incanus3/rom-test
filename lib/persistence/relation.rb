require 'rom/sql'

module Utils
  module Persistence
    class Relation < ROM::Relation[:sql]
      def by_id(id)
        where(id: id)
      end
    end
  end
end
