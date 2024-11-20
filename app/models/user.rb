class User < ApplicationRecord
    has_many :posts
    has_many :messages

    has_many :chats_as_user1, class_name: 'Chat', foreign_key: 'user1_id'
    has_many :chats_as_user2, class_name: 'Chat', foreign_key: 'user2_id'
end
