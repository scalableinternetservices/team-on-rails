class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :user
  validates :body, presence: true, length: { minimum: 1, message: "must be at least 1 character long" }
end
