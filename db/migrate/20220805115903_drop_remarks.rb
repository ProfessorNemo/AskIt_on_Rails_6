# frozen_string_literal: true

# Удаление таблицы из БД
class DropRemarks < ActiveRecord::Migration[6.0]
  def change
    drop_table :remarks do |t|
      t.string 'title'
      t.string 'body'
      t.datetime 'created_at', precision: 6, null: false
      t.datetime 'updated_at', precision: 6, null: false
      t.string 'fieldname'
    end
  end
end
