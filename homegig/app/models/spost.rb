class Spost < ApplicationRecord
    belongs_to :user
    belongs_to :category

    has_many :notifications

    scope :category, -> (category) {where category: category}
end
