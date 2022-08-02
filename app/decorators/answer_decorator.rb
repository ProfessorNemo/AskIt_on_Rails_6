# frozen_string_literal: true

class AnswerDecorator < Draper::Decorator
  delegate_all
  # Чтобы автоматически декорировать ту ассоциацию, которую мы вытаскиваем для ответа
  decorates_association :user

  def formatted_created_at
    # https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/ru.yml
    l created_at, format: :long
  end
end
