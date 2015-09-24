module ItemsHelper
  def item_field_form_for(attr, type = :inline, options = {})
    if admin?
      haml_tag :form, options,
        class: "form-#{type}",
        'ng-show' => "editing.#{attr.to_s}",
        'ng-submit' => "submit('#{attr}')" do
          yield
        end
    end
  end
end
