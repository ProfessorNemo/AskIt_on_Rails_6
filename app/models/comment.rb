# frozen_string_literal: true

class Comment < ApplicationRecord
  # данный комментарий принадлежит некой виртуальной модели, которую можно комментировать
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true, length: { minimum: 2 }

  # commentable - либо ответ, либо вопрос
  def for?(commentable)
    # Если commentable задекорирован, то нужно вытащить конкретный образец класса,
    # потому что draper наворачивает аттрибуты на задекор-й объект.
    commentable = commentable.object if commentable.decorated?
    # self указывает на конкретный комментарий и когда говорим "self.commentable",
    # мы понимаем, для чего комментарий был оставлен (вопроса или ответа)
    commentable == self.commentable
  end
end
