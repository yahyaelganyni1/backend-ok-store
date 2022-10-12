class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :carts, :through => :cartitems

  has_one_attached :image

  validates :category_id, presence: true

end
