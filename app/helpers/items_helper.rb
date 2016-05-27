module ItemsHelper
  def item_form_for(attr, options = {})
    if admin?
      options[:class] ? options[:class] << ' form-horizontal' : options[:class] = 'form-horizontal'
      options[:'ng-show'] = "editing.#{attr.to_s}"
      options[:'ng-submit'] = "submit('#{attr}'#{options[:to_change] && ', true'})"
      haml_tag :form, options do
          yield
        end
    end
  end

  def item_field_for(attr, options = {})
    if admin?
      options[:class] ? options[:class] << ' form-inline' : options[:class] = 'form-inline'
      options[:'ng-show'] = "editing.#{attr.to_s}"
      options[:'ng-submit'] = "submit('#{attr}'#{options[:to_change] && ', true'})"
      haml_tag :form, options do
          yield
        end
    end
  end
end
