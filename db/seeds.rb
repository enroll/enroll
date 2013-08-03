puts "Creating seed data"
puts "=================="

Course.delete_all
User.delete_all
Reservation.delete_all

instructor = User.create!(email: "instructor@example.com", password: "password")
puts "Created 1 user."

location = Location.create!(
  name: "Moscone Center West",
  address: "250 4th Street",
  address_2: "Suite 150",
  city: "San Francisco",
  state: "CA",
  zip: "94107",
  phone: "403.288.1927"
)
puts "Created 1 location."

Course.create!(
  name: "Test-Driven Development for Rails",
  tagline: "Spend hours writing tests, but do it first.",
  starts_at: 3.days.from_now,
  ends_at: 3.days.from_now + 4.hours,
  description: "Level up as a developer that builds levels.",
  instructor: instructor,
  location: location,
  min_seats: 10,
  max_seats: 25,
  price_per_seat_in_cents: 85000,
  instructor_biography: "Scrooge McDuck has taught 2 courses before."
)
Course.create!(
  name: "How to launch your startup",
  tagline: "Learn how to spend $5 MM in stealth mode building a product
  that nobody is going to buy",
  starts_at: 1.month.from_now,
  ends_at: 1.month.from_now + 4.hours,
  description: "Be YCombinator's next success after taking this class!",
  instructor: instructor,
  location: location,
  min_seats: 100,
  max_seats: 225,
  price_per_seat_in_cents: 1400000,
  instructor_biography: "Scrooge McDuck has taught 2 courses before."
)
puts "Created 2 courses."
