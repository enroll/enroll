puts "Creating seed data"
puts "=================="

Course.delete_all
Reservation.delete_all

rails_course        = Course.create!(:name => "Test-Driven Development for Rails")
lean_startup_course = Course.create!(:name => "How to launch your startup")
puts "Created 2 courses."
