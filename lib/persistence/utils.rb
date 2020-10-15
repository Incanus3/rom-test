require 'entities'
require 'rom/sql'

module Persistence
  module CommonViews
    def by_id(id)
      where(id: id)
    end
  end

  class BaseRelation < ROM::Relation[:sql]
    struct_namespace Entities
    auto_struct true

    include CommonViews
  end
end
