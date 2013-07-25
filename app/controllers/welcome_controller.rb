class WelcomeController < ApplicationController
  def index
    @instructor = Instructor.new
    @course = Course.new
  end
end
