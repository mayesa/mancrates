require 'rails_helper'

RSpec.describe Product, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:stock) }

  describe 'available' do
    let(:product_a) { Product.create(name: 'Product A', price: rand(100), stock: rand(100)) }
    let(:product_b) { Product.create(name: 'Product B', price: rand(100), stock: rand(100)) }
    let(:product_c) { Product.create(name: 'Product C', price: rand(100), stock: 0) }
    let(:product_d) { Product.create(name: 'Product D', price: rand(100), stock: 0) }
    let(:expected_products) { [product_a, product_b] }
    let(:not_expected_products) { [product_c, product_d] }
    it 'returns products with stock > 0', :aggregate_failures do
      expect(Product.available).to include(*expected_products)
      expect(Product.available).to_not include(*not_expected_products)
    end
  end
end
