module App
  module Persistence
    module Migrations
      module_function

      def apply(gateway)
        gateway.create_table(:users) do
          primary_key :id

          column :name,     String
          column :age,      Integer
          column :birthday, String
        end

        gateway.create_table(:tasks) do
          primary_key :id

          foreign_key :user_id, :users

          column :title, String
        end
      end
    end
  end
end
