class Tag < ApplicationRecord
  # Отношение между вопросом и тегом. Т.е. у тега есть верхняя
  # таблица, а через нее устанавливаем отношение с нижней таблицей
  has_many :question_tags, dependent: :destroy
  has_many :questions, through: :question_tags

  # Название должно быть и проверять уникальность названия, чтобы не
  # создавались одинаковые теги
  validates :title, presence: true, uniqueness: true
end
