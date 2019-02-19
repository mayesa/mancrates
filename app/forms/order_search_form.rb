class OrderSearchForm
  include ActiveModel::Model

  attr_accessor :order_id, :from, :to, :statuses

  def filled?
    order_id.present? || from.present? || to.present? || statuses.present?
  end

  def order_statuses
    @order_statuses ||= Order.aasm.states.map(&:name)
  end
end
