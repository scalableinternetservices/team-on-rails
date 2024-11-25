class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_many :stars, dependent: :destroy
    has_many :starring_users, through: :stars, source: :user
    validates :body, presence: true, length: { minimum: 8, message: "must be at least 8 characters long" }

    def starred_by?(user)
        stars.exists?(user_id: user.id)
    end

    # Validations
    validate :body_blacklist

    BLACKLIST = ["Trump", "Donald Trump", "MAGA", "Kamala", "Kamala Harris", "election", "Witch hunt", "Make America Great Again", "The radical left"]
    private
    def body_blacklist
        if BLACKLIST.any? { |word| body.downcase.include?(word.downcase) }
            errors.add(:body, "Post may potentially influence the election. Not allowed")
        end
    end
end
