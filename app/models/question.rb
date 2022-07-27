# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  validates :title, presence: true, length: { minimum: 2 }
  validates :body, presence: true, length: { minimum: 2 }

  # "self" перед created_at не говорим, потому что метод вызывается
  # относительно конкретного образца класса
  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
