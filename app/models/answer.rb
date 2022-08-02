# frozen_string_literal: true

class Answer < ApplicationRecord
  include Commentable
  # Ответ принадлежит и вопросу и юзеру
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 5 }
end
