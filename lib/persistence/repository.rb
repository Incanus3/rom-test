require 'rom/repository'

module Utils
  module Persistence
    class Repository < ROM::Repository::Root
      commands :create, update: :by_pk, delete: :by_pk

      def all
        root.to_a
      end

      def delete_all
        root.delete()
      end

      def find(pk)
        root.by_pk(pk).one!
      end

      def by_id(id)
        root.by_id(id)
      end

      def create_many(tuples)
        root.command(:create, result: :many).call(tuples)
      end
    end
  end
end
