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

  def dashboard_check_link(title, url_options, checked)
    klasses = []
    is_active = url_options.all? { |option, value| params[option] == value }
    klasses << 'active' if is_active
    content_tag :li, :class => klasses.join(' ') do
      link_to title, url_options
    end
  end

  def dashboard_check_link_step(title, step, checked)
    dashboard_check_link title, {
      controller: 'dashboard/courses',
      action: 'edit',
      step: step
    }, checked
  end
end