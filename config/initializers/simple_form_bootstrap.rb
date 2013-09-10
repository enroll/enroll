SimpleForm.setup do |config|
  config.wrappers :bootstrap, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'controls' do |ba|
      ba.use :input
      ba.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block text-danger' }
    end
  end

  config.wrappers 'bootstrap-horizontal', tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper tag: 'div', class: 'col-md-10' do |ba|
      ba.use :input
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
      ba.use :error, wrap_with: { tag: 'span', class: 'help-block text-danger' }
    end
  end

  config.wrappers 'pricing-block', tag: 'div', class: 'form-group clearfix', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'col-md-8' do |ba|
      ba.use :label
      ba.use :hint,  wrap_with: { tag: 'p', class: 'help-block' }
    end
    b.wrapper tag: 'div', class: 'col-md-4' do |ba|
      ba.use :input
    end
  end

  config.default_wrapper = :bootstrap
end
