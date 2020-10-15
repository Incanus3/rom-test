$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

require 'rom'

require 'persistence/repositories'
require 'persistence/migrations'

config = ROM::Configuration.new(:sql, 'sqlite::memory') do |config|
  config.auto_registration(File.join(__dir__, 'lib/persistence'))
end

container = ROM.container(config)
user_repo = Persistence::UsersRepository.new(container)
task_repo = Persistence::TasksRepository.new(container)

Persistence::Migrations.apply(container.gateways[:default])

user_tuples = [
  { id: 1, name: "Jane", age: 20, birthday: '2000-01-01' },
  { id: 2, name: "John", age: 30 }
]
task_tuples = [
  { id: 1, user_id: 1, title: "Jane's task" },
  { id: 2, user_id: 2, title: "John's task" }
]

user_repo.create_many(user_tuples)
task_repo.create_many(task_tuples)

puts "all users:"
pp user_repo.all
puts "all tasks:"
pp task_repo.all
puts "john:"
pp user_repo.find(2)
puts "john with his tasks:"
pp user_repo.with_tasks.by_name('John').one!
puts "task 2 with its user:"
task_with_user = user_repo.tasks.by_id(2).combine(:users).one!
pp task_with_user
pp task_with_user.user
