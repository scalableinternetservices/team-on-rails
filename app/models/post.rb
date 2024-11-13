class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    validates :body, presence: true, length: { minimum: 8, message: "must be at least 8 characters long" }

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
