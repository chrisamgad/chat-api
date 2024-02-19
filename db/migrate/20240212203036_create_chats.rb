class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :application, foreign_key: true
      t.integer :number, null: false
      t.integer :messages_count, default: 0
      t.timestamps

      t.index [:number, :application_id], unique: true

      end
  end
end
