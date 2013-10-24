class AddPaymentSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :account_number, :string
    add_column :users, :routing_number, :string
  end
end
