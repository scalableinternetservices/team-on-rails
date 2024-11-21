class User < ApplicationRecord
    has_many :posts
    has_and_belongs_to_many :meetings
    
    validates :role, inclusion: { in: ['student', 'instructor'] }
    
    def student?
        role == 'student'
    end
    
    def instructor?
        role == 'instructor'
    end
end
