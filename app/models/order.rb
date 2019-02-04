class Order < ApplicationRecord
  include AASM

  aasm do
    state :processing, initial: true
    state :awaiting_pickup
    state :in_transit
    state :out_for_delivery
    state :delivered

    event :pack do
      transitions from: [:processing], to: :awaiting_pickup#, before: before_pack
    end

    event :pick_up do
      transitions from: [:awaiting_pickup], to: :in_transit
    end

    event :fedex_verify do
      transitions from: [:in_transit], to: :out_for_delivery
    end

    event :deliver do
      transitions from: [:out_for_delivery], to: :delivered
    end
  end

  SHIPPING_METHODS = ['default', 'fast', 'super-fast'].freeze

  belongs_to :product

  validates :product, :customer_name, :adress, :zip_code, :shipping_method, :aasm_state, presence: true

  scope :in_status, ->(status) { where("aasm_state IN (?)", status) }
  scope :created_before, ->(date) { where("created_at <= ?", date) }
  scope :created_after,  ->(date) { where("created_at >= ?", date) }

  def before_pack
    self.fedex_id = SecureRandom.uuid
  end

  def self.shipping_methods
    SHIPPING_METHODS
  end

  def self.total_count
    Order.count
  end

  def total
    product.price
  end

  def status
    aasm_state
  end
end
