class WelcomeController < ApplicationController
  def index
    @user = User.new
    @course = Course.new
  end
end
