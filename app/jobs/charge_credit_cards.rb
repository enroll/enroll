class ChargeCreditCards
  @queue = :notifications

  def self.perform(id)
    Course.find(id).charge_credit_cards!
  end
end