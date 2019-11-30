class Post < ApplicationRecord
    mount_uploader :gig_image, ImageUploader

    belongs_to :user
    belongs_to :category
    has_many :reviews, dependent: :destroy

    has_many :notifications

    scope :category, -> (category) {where category: category}

    validates :title, :content, :price, presence:true
    validates :content, length:{in: 10..200}
    validates :title, length:{in: 5..20}
    validates :price, numericality: { only_integer: true, greater_than:0}
end
