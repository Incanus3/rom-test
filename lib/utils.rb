require 'dry/inflector'
require 'dry/transformer'

module Utils
  String = Dry::Inflector.new.freeze
  Array  = Dry::Transformer::ArrayTransformations
  Hash   = Dry::Transformer::HashTransformations
end
