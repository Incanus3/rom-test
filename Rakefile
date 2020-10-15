APP_ROOT = File.expand_path(__dir__)

$LOAD_PATH.unshift(APP_ROOT)

require 'rom/sql/rake_task'
require 'app/dependencies'

App::Dependencies.start(:persistence)

namespace :db do
  task :setup do
    ROM::SQL::RakeSupport.env = App::Dependencies[:db]
  end
end
