# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  # создается отношение на стороне Question
  # если удаляется вопрос, то и все зависимые ответы
  has_many :answers, dependent: :destroy
  belongs_to :user

  # Логика проверки двух полей в БД
  # Чтобы не отправляли пустые вопросы, используем проверки, чтобы
  # был title и body, т.е. true. И минимальная длина не меньше 2
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }
end
