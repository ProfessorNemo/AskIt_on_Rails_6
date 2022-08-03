# frozen_string_literal: true

class Question < ApplicationRecord
  include Commentable
  # создается отношение на стороне Question
  # если удаляется вопрос, то и все зависимые ответы
  has_many :answers, dependent: :destroy
  belongs_to :user

  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  # Логика проверки двух полей в БД
  # Чтобы не отправляли пустые вопросы, используем проверки, чтобы
  # был title и body, т.е. true. И минимальная длина не меньше 2
  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  # scope - метод класса в RoR, который можно вызвать, т.е "scope :all_by_tags"
  # равносильно "all_by_tags(params[:tag_ids])", т.е. можно было написать
  # "def self.all_by_tags", разницы нет.
  # С помощью scope мы можем выбирать определенные записи по каким то критериям
  scope :all_by_tags, lambda { |tags|
    questions = includes(:user)
    questions = if tags
                  # связка в SQL с таблице тегов, где теги - это "tags", только если он существует
                  questions.joins(:tags).where(tags: tags).preload(:tags)
                else
                  questions.includes(:question_tags, :tags)
                end
    # либо выбираем все вопросы
    questions.order(created_at: :desc)
  }
end
