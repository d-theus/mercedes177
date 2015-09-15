module ApplicationHelper
  DEFAULT_KEYWORDS = %w(автозапчасти мерседес mercedes авторазбор)

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
    Rails.env.development? || ( current_user && current_user.admin? )
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

  def navbar_link(args)
    current = (controller_name == args[:controller].to_s and action_name == args[:action].to_s)
    Rails.logger.info 'Controller:' + controller_name
    Rails.logger.info 'Action:' + action_name

    if current 
      haml_tag(:a, title: 'Главная', href: root_path) do
        haml_concat 'Главная'
      end
    else
      haml_tag(:a, title: args[:title] || args[:text], href: url_for(controller: args[:controller], action: args[:action])) do
        yield
      end
    end
  end
end
