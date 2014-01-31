class AddVisitorIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :visitor_id, :string
  end
end
