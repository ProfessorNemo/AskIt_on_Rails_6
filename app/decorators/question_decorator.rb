# frozen_string_literal: true

class QuestionDecorator < Draper::Decorator
  delegate_all
  # Чтобы автоматически декорировать ту ассоциацию, которую мы вытаскиваем для вопроса
  decorates_association :user

  # "self" перед created_at не говорим, потому что метод вызывается
  # относительно конкретного образца класса
  def formatted_created_at
    # https://github.com/svenfuchs/rails-i18n/blob/master/rails/locale/ru.yml
    l created_at, format: :long
  end
end
