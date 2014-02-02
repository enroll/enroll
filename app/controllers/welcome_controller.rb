class WelcomeController < ApplicationController
  def index
    mixpanel_track_event 'Welcome Page'
    
  	if current_user
  		return redirect_to courses_path
  	end

    @user = User.new
    @course = Course.new
  end
end
