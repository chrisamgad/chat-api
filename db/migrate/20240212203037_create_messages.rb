class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :chat, foreign_key: true, index:true
      t.integer :number, null: false
      t.text :content
      t.timestamps

      t.index [:number, :chat_id], unique: true
    end
  end
end
