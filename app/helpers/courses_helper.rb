module CoursesHelper
  def editable_input(form, name, options={})
    options[:input_html] ||= {}
    options[:input_html][:class] ||= 'workshop-input'
    options[:input_html][:placeholder] ||= options[:label]
    options[:container_html] ||= {}
    options[:label] ||= name.to_s.titleize
    render 'courses/editable_input', form: form, name: name, options: options
  end
end
