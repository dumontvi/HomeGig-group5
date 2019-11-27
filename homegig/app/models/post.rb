class Post < ApplicationRecord
    belongs_to :user
    belongs_to :category
    has_many :reviews, dependent: :destroy

    has_many :notifications

    scope :category, -> (category) {where category: category}
end
