# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table(:users) do
      primary_key :id

      column :name,     String
      column :age,      Integer
      column :birthday, String
    end
  end
end
