class AddContentEnToMessageTemplates < ActiveRecord::Migration[6.1]
  def change
    add_column :message_templates, :content_en, :text
  end
end
