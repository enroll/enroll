class WelcomeController < ApplicationController
  def index
  	if current_user
  		return redirect_to courses_path
  	end

    @user = User.new
    @course = Course.new
  end

  def boom
    raise "hell"
  end
end
