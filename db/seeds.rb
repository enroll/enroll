puts "Creating seed data"
puts "=================="

Course.delete_all
User.delete_all
Reservation.delete_all

instructor = User.create!(email: "instructor@example.com", password: "password")
student    = User.create!(email: "student@example.com",    password: "password")
student1   = User.create!(email: "student1@example.com",   password: "password")
student2   = User.create!(email: "student2@example.com",   password: "password")
students   = [student, student1, student2]
puts "Created 4 users."

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

course1 = Course.create!(
  name: "Test-Driven Development for Rails",
  tagline: "Spend hours writing tests, but do it first.",
  starts_at: 3.days.from_now,
  ends_at: 3.days.from_now + 4.hours,
  campaign_ends_at: 1.day.from_now,
  description: "Level up as a developer that builds levels.",
  instructor: instructor,
  location: location,
  min_seats: 10,
  max_seats: 25,
  price_per_seat_in_cents: 85000,
  instructor_biography: "Scrooge McDuck has taught 2 courses before."
)
course2 = Course.create!(
  name: "How to launch your startup",
  tagline: "Learn how not to spend $5 MM in stealth mode building a product
  that nobody is going to buy",
  starts_at: 2.month.from_now,
  ends_at: 2.month.from_now + 4.hours,
  campaign_ends_at: 1.month.from_now,
  description: "Be YCombinator's next success after taking this class!",
  instructor: instructor,
  location: location,
  min_seats: 100,
  max_seats: 225,
  price_per_seat_in_cents: 1400000,
  instructor_biography: "Scrooge McDuck has taught 2 courses before."
)
puts "Created 2 courses."

# Students sign up for course 1
students.each do |student|
  Reservation.create!(
    course: course1,
    student: student
  )
end
puts "Created 3 reservations."