class Tag < ApplicationRecord
    has_many :tweets, :dependent => :delete_all

    validates :name, presence: true, uniqueness: true

    default_scope { order(name: :asc) }
end
