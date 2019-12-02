class User < ApplicationRecord
  mount_uploader :profile_picture, ImageUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  has_many :sposts, dependent: :destroy
  has_many :gigs, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validates_uniqueness_of :name
  validates :name, presence:true, length:{in: 3..20}
  validates :about, length:{in: 1..200}
end
