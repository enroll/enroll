class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  helper_method :body_classes
  def body_classes
    classes = (@body_classes || []) + [controller_name, action_name, namespace_name]
    classes.join(' ')
  end

  def add_body_class(klass)
    @body_classes ||= []
    @body_classes << klass
  end

  def namespace_name
    self.class.to_s.split("::").first.downcase
  end

  # Mixpanel
  def mixpanel
    return nil unless Enroll.mixpanel_token

    unless @mixpanel
      @mixpanel = Mixpanel::Tracker.new(Enroll.mixpanel_token)
      @mixpanel.set current_user.email, {email: current_user.email} if current_user
    end
    
    @mixpanel
  end

  def mixpanel_track_event(event, options)
    return unless mixpanel

    distinct_id = options[:distinct_id] || visitor_id
    mixpanel.track(event, {distinct_id: distinct_id})
  end

  def visitor_id
    @visitor_id ||= if current_user
      if current_user.visitor_id
        current_user.visitor_id
      else
        current_user.visitor_id = generate_visitor_id!
        current_user.save!(validate: false)
      end
    else
      generate_visitor_id!
    end

    @visitor_id
  end

  def generate_visitor_id!
    if cookies[:visitor_id]
      cookies[:visitor_id]
    else
      id = SecureRandom.base64
      cookies.permanent[:visitor_id] = id
      id
    end
  end
end
