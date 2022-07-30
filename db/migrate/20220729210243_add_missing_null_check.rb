# frozen_string_literal: true

class AddMissingNullCheck < ActiveRecord::Migration[6.1]
  def change
    # false - данная колонка пустой быть не может
    # :questions - название таблицы
    # :title - название колоники
    change_column_null :questions, :title, false
    change_column_null :questions, :body, false
    change_column_null :answers, :body, false
  end
end
