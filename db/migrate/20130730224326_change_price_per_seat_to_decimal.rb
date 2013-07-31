class ChangePricePerSeatToDecimal < ActiveRecord::Migration
  def change
    change_column :courses, :price_per_seat, :decimal, precision: 16, scale: 2, default: 0
  end
end
