module ApplicationHelper
  DEFAULT_KEYWORDS = %w(автозапчасти мерседес mercedes авторазбор)
  NG_APPS = %w(catalog orders)

  def title_tag
    str = "Автозапчасти Mercedes"
    str << " | #{content_for(:title).strip}" if content_for?(:title)
    raw "<title>#{str}</title>"
  end

  def meta_description
    return unless content_for? :meta_description
    raw "<meta name='description' content='#{content_for(:meta_description).strip}'>"
  end

  def meta_keywords
    kwords = ""
    kwords << "#{content_for(:meta_keywords).strip}, " if content_for?(:meta_keywords)
    kwords << DEFAULT_KEYWORDS
    raw "<meta name='keywords' content='#{kwords}'>"
  end

  def admin?
    #Rails.env.development? || ( current_user && current_user.admin? )
    false
  end

  def page_title(title)
    content_for :title do 
      haml_concat title
    end
      haml_tag :div, class: :row do
        haml_tag :center, class: 'col-xs-12' do
          haml_tag :h1 do
            haml_concat title
          end
        end
      end
  end

  def v_submit_tag(opts = {})
    defaults = { class: %i(btn btn-warning), type: :submit }
    final = defaults.merge opts
    haml_tag :button, final do
      haml_tag :span, class: %i(fa fa-check)
    end
  end

  def ng_app
    controller_name if NG_APPS.include? controller_name
  end
end
