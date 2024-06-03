class ChangeSentAtToBeNotNullInMessages < ActiveRecord::Migration[6.1]
  def change
    change_column_null :messages, :sent_at, false
  end
end
