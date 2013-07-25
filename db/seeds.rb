puts "Creating seed data"
puts "=================="

Course.delete_all
Instructor.delete_all
Reservation.delete_all

instructor = Instructor.create!(email: "instructor@example.com", password: "password")
puts "Created 1 instructor."

Course.create!(name: "Test-Driven Development for Rails", instructor: instructor)
Course.create!(name: "How to launch your startup", instructor: instructor)
puts "Created 2 courses."
