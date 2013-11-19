module ApplicationHelper
  def gravatar_for(email, options = {})
    options = {:alt => 'avatar', :class => 'img-rounded', :size => 30}.merge! options
    id = email.blank? ? "00000000000000000000000000000000" : Digest::MD5::hexdigest(email.strip.downcase)
    url = 'https://www.gravatar.com/avatar/' + id + '.jpg?s=' + options[:size].to_s + '&d=retro'
    options.delete :size
    image_tag url, options
  end

  def classed(class_name, controller, action)
    if controller_name == controller && action_name == action
      class_name
    else
      ''
    end
  end
end
