class Tag < ApplicationRecord
    has_many :tweets, :dependent => :delete_all

    default_scope { order(name: :asc) }
    validates :name, presence: true, uniqueness: true
end
