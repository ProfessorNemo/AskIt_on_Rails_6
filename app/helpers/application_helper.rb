# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  # данная навигация показывается в том случае, если количество страниц больше 1
  def pagination(obj)
    # raw - для обработки разметки правильным образом
    # rubocop:disable Rails/OutputSafety
    raw(pagy_bootstrap_nav(obj)) if obj.pages > 1
    # rubocop:enable Rails/OutputSafety
  end

  def nav_tab(title, url, options = {})
    current_page = options.delete :current_page

    css_class = current_page == title ? 'text-secondary' : 'text-white'

    options[:class] = if options[:class]
                        "#{options[:class]} #{css_class}"
                      else
                        css_class
                      end

    link_to title, url, options
  end

  def currently_at(current_page = '')
    render partial: 'shared/menu', locals: { current_page: current_page }
  end

  def full_title(page_title = '')
    base_title = 'AskIt'
    if page_title.present?
      "#{page_title} | #{base_title}"
    else
      base_title
    end
  end

  # для того, чтобыт при выборе локали не редиректило каждый раз на главную страницу
  def params_plus(additional_params)
    params.to_unsafe_h.merge(additional_params)
  end
end
