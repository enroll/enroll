module FormatHelper
  def number_to_currency_from_cents(value, options={})
    number_to_currency((value || 0) / 100.0, options)
  end

  def price_in_dollars(price_in_cents)
    (price_in_cents.to_f / 100) if price_in_cents
  end
end
