class AddLastMessageUserIdToChats < ActiveRecord::Migration[7.1]
  def change
    add_column :chats, :last_message_user_id, :integer
  end
end
