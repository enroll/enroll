# Stripe Integration

## Create a valid Recipient

```ruby
Stripe::Recipient.create(
  :name => "Julia Childs",
  :type => "individual",
  :tax_id => "000000000",
  :bank_account => {
    :country => "US",
    :routing_number => "110000000",
    :account_number => "000123456789"
   }
 )
```

* Utilize `Stripe::Recipient` with ID: `rp_2FUrV5Zn4ILgfo`
