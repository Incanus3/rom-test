require 'lib/utils'
require 'lib/persistence/container'

require 'app/entities'

require_relative 'repositories/clients'
require_relative 'repositories/registrations'

module App
  module Persistence
    class Container < Utils::Persistence::Container
      DEFAULT_CONFIG_OPTIONS = {
        migrator: {
          path: File.join(APP_ROOT, 'app', 'persistence', 'migrations')
        },
        auto_registration: {
          root_dir: File.join(APP_ROOT, 'app', 'persistence'),
          namespace: 'App::Persistence'
        },
      }.freeze

      DEFAULT_REPO_OPTIONS = {
        auto_struct:      true,
        struct_namespace: App::Entities
      }.freeze

      register_repo(Persistence::Repositories::Clients)
      register_repo(Persistence::Repositories::Registrations)
    end
  end
end
