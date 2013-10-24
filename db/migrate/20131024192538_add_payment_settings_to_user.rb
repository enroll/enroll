class AddPaymentSettingsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :stripe_recipient_id, :string
  end
end
