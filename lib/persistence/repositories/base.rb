require 'rom/repository'

module Persistence
  class BaseRepository < ROM::Repository::Root
    commands :create, update: :by_pk, delete: :by_pk

    def all
      root.to_a
    end

    def find(pk)
      root.by_pk(pk).one!
    end

    def create_many(tuples)
      root.command(:create, result: :many).call(tuples)
    end
  end
end
