class ChangePricePerSeat < ActiveRecord::Migration
  def change
    rename_column :courses, :price_per_seat, :price_per_seat_in_cents
  end
end
