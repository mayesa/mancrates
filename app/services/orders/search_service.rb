require 'ostruct'

class Orders::SearchService
  attr_accessor :current_user

  def self.build(current_user)
    new(current_user)
  end

  def initialize(current_user)
    self.current_user = current_user
  end

  def call(search_form)
    orders = Order.all
    if search_form.filled?
      orders = orders.where(id: search_form.order_id) if search_form.order_id.present?
      orders = orders.created_after(search_form.from.to_date) if search_form.from.present?
      orders = orders.created_before(search_form.to.to_date) if search_form.to.present?
      orders = orders.in_status(search_form.statuses) if search_form.statuses.present?
    end
    orders
  end
end
