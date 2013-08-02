module FormatHelper
  def number_to_currency_from_cents(value, options={})
    number_to_currency((value || 0) / 100.0, options)
  end
end
