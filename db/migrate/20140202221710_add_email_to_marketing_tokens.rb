class AddEmailToMarketingTokens < ActiveRecord::Migration
  def change
    add_column :marketing_tokens, :email, :string
  end
end
