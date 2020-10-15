$LOAD_PATH.unshift(File.join(__dir__))

require 'app/persistence/container'
require 'app/persistence/migrations'

db = App::Persistence::Container.new

App::Persistence::Migrations.apply(db.gateways[:default])

user_tuples = [
  { id: 1, name: "Jane", age: 20, birthday: '2000-01-01' },
  { id: 2, name: "John", age: 30 }
]
task_tuples = [
  { id: 1, user_id: 1, title: "Jane's task" },
  { id: 2, user_id: 2, title: "John's task" }
]

db.users.create_many(user_tuples)
db.tasks.create_many(task_tuples)

puts "all users:"
pp db.users.all
puts "all tasks:"
pp db.tasks.all
puts "john:"
pp db.users.find(2)
puts "john with his tasks:"
pp db.users.with_tasks.by_name('John').one!
puts "task 2 with its user:"
task_with_user = db.tasks.by_id(2).combine(:users).one!
pp task_with_user
pp task_with_user.user
