class Post < ApplicationRecord
    belongs_to :user
    belongs_to :category
    has_many :reviews, dependent: :destroy

    scope :category, -> (category) {where category: category}
end
