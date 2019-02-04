require 'rails_helper'

RSpec.describe Order, type: :model do
  it { is_expected.to validate_presence_of(:product) }
  it { is_expected.to validate_presence_of(:customer_name) }
  it { is_expected.to validate_presence_of(:adress) }
  it { is_expected.to validate_presence_of(:zip_code) }
  it { is_expected.to validate_presence_of(:shipping_method) }
  it { is_expected.to validate_presence_of(:aasm_state) }

  describe '.shipping_methods' do
    let(:expected_shipping_methods) { ['default', 'fast', 'super-fast'] }
    it 'returns available shipping_methods' do
      expect(Order.shipping_methods).to eq expected_shipping_methods
    end
  end

  describe '#total' do
    let(:order) { Order.new(product: product) }
    let(:product) { Product.new(price: rand(1000)) }
    let(:expected_total) { product.price  }
    it 'returns the order total amount' do
      expect(order.total).to eq expected_total
    end
  end
end
