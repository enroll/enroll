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

  def dashboard_check_link(title, url_options, is_checked)
    klasses = []
    is_active = url_options.all? { |option, value| params[option] == value }
    klasses << 'active' if is_active
    klasses << 'checked' if is_checked

    url_options[:action] = @course.id ? 'edit' : 'new'

    content_tag :li, :class => klasses.join(' ') do
      link_to title, url_options
    end
  end

  def dashboard_check_link_step(title, step, checked)
    dashboard_check_link title, {
      controller: 'dashboard/courses',
      step: step,
    }, checked
  end

  def activity_date_format(date)
    if date.to_date == Date.today
      "Today"
    elsif date.to_date == Date.yesterday
      "Yesterday"
    else
      date.strftime("%a, %b #{date.day.ordinalize}")
    end
  end

  def icon_for_event_type(type)
    icons = {
      Event::COURSE_CREATED => 'paper-plane',
      Event::PAGE_VISITED => 'user',
      Event::STUDENT_ENROLLED => 'feather'
    }

    icon = icons[type]
    html = '<i class="icon icon-%s"></i>' % [icon]
    html.html_safe
  end
end