APP_ROOT = File.expand_path(__dir__)

$LOAD_PATH.unshift(APP_ROOT)

require 'app/dependencies'

App::Dependencies.start(:persistence)

db = App::Dependencies[:db]

user_tuples = [
  { id: 1, name: "Jane", age: 20, birthday: '2000-01-01' },
  { id: 2, name: "John", age: 30 }
]
task_tuples = [
  { id: 1, user_id: 1, title: "Jane's task" },
  { id: 2, user_id: 2, title: "John's task" }
]

db.tasks.delete_all()
db.users.delete_all()
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
