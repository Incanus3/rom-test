# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table(:tasks) do
      primary_key :id

      foreign_key :user_id, :users

      column :title, String
    end
  end
end
