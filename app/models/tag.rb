class Tag < ApplicationRecord
    has_many :tweets

    validates :name, presence: true
end
