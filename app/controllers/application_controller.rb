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
end
