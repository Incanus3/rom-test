$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

require 'rom'
require 'rom/sql'
require 'persistence/migrations'

class Repo
  def initialize(rom_container)
    @container = rom_container
  end

  def [](relation_name)
    @container.relations[relation_name]
  end

  def method_missing(relation_name)
    @container.relations[relation_name]
  end
end

config = ROM::Configuration.new(:sql, 'sqlite::memory') do |config|
  config.auto_registration(File.join(__dir__, 'lib/persistence'))
end

container = ROM.container(config)
repo      = Repo.new(container)

Persistence::Migrations.apply(container.gateways[:default])

# users = container.relations[:users]
# tasks = container.relations[:tasks]

user_tuples = [
  { id: 1, name: "Jane", age: 20, birthday: '2000-01-01' },
  { id: 2, name: "John", age: 30 }
]
task_tuples = [
  { id: 1, user_id: 1, title: "Jane's task" },
  { id: 2, user_id: 2, title: "John's task" }
]

# user_tuples.each { |tuple| users.insert(tuple) }
# task_tuples.each { |tuple| tasks.insert(tuple) }
repo.users.command(:create, result: :many).call(user_tuples)
repo.tasks.command(:create, result: :many).call(task_tuples)

puts "all users:"
pp repo.users.to_a
puts "all tasks:"
pp repo.tasks.to_a
puts "john's tasks:"
pp repo.tasks.for_users(repo.users.associations[:tasks], repo.users.where(name: 'John')).to_a
puts "john with his tasks:"
pp repo.users.where(name: "John").combine(:tasks).one! # should be the same
puts "task 2 with its user:"
task_with_user = repo.tasks.by_id(2).combine(:users).one!
pp task_with_user
pp task_with_user.user

# p Tasks.schema[:user_id].meta
