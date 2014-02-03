class WelcomeController < ApplicationController
  def index
    update_visitor_id_from_marketing_token()

    mixpanel_track_event 'Welcome Page'
    
  	if current_user
  		return redirect_to courses_path
  	end

    @user = User.new
    @course = Course.new
  end

  def about
    
  end

  protected

  def update_visitor_id_from_marketing_token
    if params[:i]
      token = MarketingToken.where(token: params[:i]).first
      return unless token

      cookies[:visitor_id] = token.distinct_id
    end
  end
end
