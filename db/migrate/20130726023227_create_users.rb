class CreateUsers < ActiveRecord::Migration
  def change
    rename_table :instructors, :users
  end
end
