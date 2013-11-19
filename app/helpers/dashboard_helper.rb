module DashboardHelper
  def dashboard_menu_link(path, label, icon, controller, action)
    klass = if controller_name == controller && action_name == action
      'active'
    else
      ''
    end
    content_tag :li, :class => klass do
      content_tag :a, "<i class='icon-#{icon}'></i> #{label}".html_safe, :href => path
    end
  end
end