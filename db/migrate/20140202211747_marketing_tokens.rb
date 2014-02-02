class MarketingTokens < ActiveRecord::Migration
  def change
    create_table :marketing_tokens do |t|
      t.string :token
      t.string :distinct_id

      t.timestamps
    end
  end
end
