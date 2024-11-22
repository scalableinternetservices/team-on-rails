class AddLastMessageIdToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :last_message_id, :integer
  end
end
