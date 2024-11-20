class User < ApplicationRecord
    has_many :posts
    has_and_belongs_to_many :meetings

    validates :username, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 8 }
end
