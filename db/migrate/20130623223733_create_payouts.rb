class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.string :stripe_transfer_id
      t.string :stripe_recipient_id
      t.string :status
      t.string :description
      t.integer :amount_in_cents
    end

    add_index :payouts, :status
  end
end
