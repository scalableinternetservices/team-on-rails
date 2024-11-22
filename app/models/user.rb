class User < ApplicationRecord
    has_many :posts
    has_and_belongs_to_many :meetings
    has_many :messages
    
    has_many :chats_as_user1, class_name: 'Chat', foreign_key: 'user1_id'
    has_many :chats_as_user2, class_name: 'Chat', foreign_key: 'user2_id'

    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 8 }
     
    validates :role, inclusion: { in: ['student', 'instructor'] }
    
    def student?
        role == 'student'
    end
    
    def instructor?
        role == 'instructor'
    end
end
