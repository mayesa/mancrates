class Product < ActiveRecord::Base
  validates :name, :price, :stock, presence: true

  scope :available, -> { where('stock > 0') }
end
