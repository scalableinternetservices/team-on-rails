class Chat < ApplicationRecord
  belongs_to :user1, class_name: 'User'
  belongs_to :user2, class_name: 'User'
  has_many :messages, dependent: :destroy

  before_save :ensure_user_order

  private

  def ensure_user_order
    # Swap user1_id and user2_id if user1_id is greater than user2_id
    if user1_id > user2_id
      self.user1_id, self.user2_id = user2_id, user1_id
    end
  end
end