class AddMessageTemplateToMessages < ActiveRecord::Migration[6.1]
  def change
    add_reference :messages, :message_template, null: false, foreign_key: true
  end
end
