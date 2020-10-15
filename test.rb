$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

require 'rom'
require 'rom/sql'

require 'relations'

config = ROM::Configuration.new(:sql, 'sqlite::memory') do |config|
  config.register_relation(Users, Tasks)
end

container  = ROM.container(config)
default_db = container.gateways[:default]

default_db.create_table(:users) do
  primary_key :id

  column :name,     String
  column :age,      Integer
  column :birthday, String
end

default_db.create_table(:tasks) do
  primary_key :id

  foreign_key :user_id, :users

  column :title, String
end

users = container.relations[:users]
tasks = container.relations[:tasks]

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
users.command(:create, result: :many).call(user_tuples)
tasks.command(:create, result: :many).call(task_tuples)

puts "all users:"
pp users.to_a
puts "all tasks:"
pp tasks.to_a
puts "john's tasks:"
pp tasks.for_users(users.associations[:tasks], users.where(name: 'John')).to_a
puts "john with his tasks:"
pp users.where(name: "John").combine(:tasks).one! # should be the same
puts "task 2 with its user:"
task_with_user = tasks.by_id(2).combine(:users).one!
pp task_with_user
pp task_with_user.user

# p Tasks.schema[:user_id].meta
