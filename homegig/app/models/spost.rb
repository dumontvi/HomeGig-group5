class Spost < ApplicationRecord
    belongs_to :user
    belongs_to :category

    scope :category, -> (category) {where category: category}
end
