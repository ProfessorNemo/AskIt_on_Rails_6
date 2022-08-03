class CreateQuestionTags < ActiveRecord::Migration[6.1]
  def change
    create_table :question_tags do |t|
      t.belongs_to :question, null: false, foreign_key: true
      t.belongs_to :tag, null: false, foreign_key: true

      t.timestamps
    end

    # Для того, чтоб в таблице не появилось двух записей, у которых одинаковый
    # question_id и tag_id
    add_index :question_tags, %i[question_id tag_id], unique: true
  end
end
