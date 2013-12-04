module DashboardHelper
  def dashboard_menu_link(path, label, icon, controller, action, &block)
    klass = if controller_name == controller && action_name == action
      'active'
    else
      ''
    end
    content_tag :li, :class => klass do
      content_tag :a, :href => path do
        content = capture_haml(&block) if block_given?
        content_tag(:i, '', :class => "icon-#{icon}") + ' ' + label + ' ' + content
      end
    end
  end
end