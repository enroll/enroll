module VisualSelectHelper
  def visual_select_sequence
    @visual_select_counter ||= 0
    @visual_select_counter += 1
  end

  def visual_select(model, method, options = {})
    collection = options[:collection]
    klass = options[:class] || ""
    form = options[:form]
    id = "visual-select-#{visual_select_sequence}"
    selector = "##{id}"
    capture_haml do
      haml_tag 'div', :class => "choices #{klass}", :id => id do
        haml_concat form.input_field(method, :as => :hidden)
        collection.each do |item|
          haml_tag 'div', :class => 'choice', :"data-id" => item[:id] do
            yield(item)
          end
        end
      end

      haml_tag "script" do
        haml_concat %{new VisualSelect({el: "#{selector}"})}
      end
    end
  end
end
