# frozen_string_literal: true

class RemoveDefaultUserIdFromQuestionsAnswers < ActiveRecord::Migration[6.1]
  # up и down - методы, которые вызываются при применении миграции и при откате

  # Удалить дефолтное значение с колонки "user_id" в двух таблицах. Для этого используется
  # "change_column_default". Но здесь мы нигде не объясняем какое дефолтное значение было раньше.
  # Чтобы сделать ее точно откатываемой - "from: User.first.id (какое было), to: nil (какое стало)"
  def up
    change_column_default :questions, :user_id, from: User.first.id, to: nil
    change_column_default :answers, :user_id, from: User.first.id, to: nil
  end

  # Возврат на шаг назад, т.е. наоборот
  def down
    change_column_default :questions, :user_id, from: nil, to: User.first.id
    change_column_default :answers, :user_id, from: nil, to: User.first.id
  end
end
