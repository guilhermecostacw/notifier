class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :customer, null: false, foreign_key: true
      t.text :content
      t.datetime :sent_at

      t.timestamps
    end
  end
end
