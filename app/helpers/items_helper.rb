module ItemsHelper
  def item_field_form_for(attr, type = :inline)
    if admin?
      haml_tag :form,
        class: "form-#{type}",
        'ng-show' => "editing.#{attr.to_s}",
        'ng-submit' => "submit('#{attr}')" do
          yield
        end
    end
  end
end
