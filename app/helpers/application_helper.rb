module ApplicationHelper
  def gravatar_for(email, options = {})
    options = {:alt => 'avatar', :class => 'img-rounded', :size => 30}.merge! options
    id = email.blank? ? "00000000000000000000000000000000" : Digest::MD5::hexdigest(email.strip.downcase)
    url = 'https://www.gravatar.com/avatar/' + id + '.jpg?s=' + options[:size].to_s + '&d=retro'
    options.delete :size
    image_tag url, options
  end

  def icon(icon)
    ('<i class="icon-%s"></i>' % icon).html_safe
  end

  # Render that supports passing a block
  # Shortcut to `render layout: '...', locals: {...}`
  def yrender(partial, locals, &block)
    render(layout: partial, locals: locals, &block)
  end

  def short_date(date)
    return nil unless date
    date.strftime("%a,&nbsp;%b&nbsp;#{date.day.ordinalize}").html_safe
  end

  def long_date(date)
    return nil unless date
    date.strftime("%B %e, %Y")
  end
end
