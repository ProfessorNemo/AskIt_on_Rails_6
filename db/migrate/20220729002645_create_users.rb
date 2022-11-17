# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true }
      t.string :name
      t.string :password_digest
      t.string :gravatar_hash
      # по умолчанию все с правами доступа юзера ("default: 0, null: false")
      t.integer :status, default: 0, null: false
      t.integer :role, default: 0, null: false

      t.timestamps
    end

    add_index :users, :role
  end
end
