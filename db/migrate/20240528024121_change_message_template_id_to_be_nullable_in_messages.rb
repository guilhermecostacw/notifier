class ChangeMessageTemplateIdToBeNullableInMessages < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messages, :message_template_id, true
  end
end
