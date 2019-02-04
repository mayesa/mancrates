class Orders::UpdateShippingStatusService
  CHECK_AWAITING_PICKUP_ORDERS_EVERY = 12.hours
  CHECK_IN_TRANSIT_ORDERS_EVERY      = 6.hours

  def self.call
    process_awaiting_pickup_orders
    process_in_transit_orders
    process_out_for_delivery_orders
  end

  def self.process_awaiting_pickup_orders
    awaiting_pickup_orders.each do |order|
      shipment = Fedex::Shipment.find(order.fedex_id)
      order.pick_up if shipment.status == 'in_transit'
      order.fedex_status_checked_at = Time.now
      order.save
    end
  end

  # Finds awaiting_pickup_orders. Since FedEx comes by once a day to pick up
  # waiting_pickup orders, we can run this check every CHECK_AWAITING_PICKUP_ORDERS_EVERY
  # hours instead of 15 minutes.
  #
  # @return [Order] all orders in 'awaiting_pickup' status that were not checked
  # in the last CHECK_AWAITING_PICKUP_ORDERS_EVERY hours.
  def self.awaiting_pickup_orders
    Order.where(fedex_status_checked_at: nil)
         .or(Order.where('fedex_status_checked_at < ?', CHECK_AWAITING_PICKUP_ORDERS_EVERY.ago))
         .awaiting_pickup
  end

  def self.process_in_transit_orders
    in_transit_orders.each do |order|
      shipment = Fedex::Shipment.find(order.fedex_id)
      order.fedex_verify if shipment.status == 'out_for_delivery'
      order.fedex_status_checked_at = Time.now
      order.save
    end
  end

  # Finds in_transit_orders. Since the order can take some time to arrive to
  # Fedex facilities + verify we can check this one every CHECK_IN_TRANSIT_ORDERS_EVERY
  # hours instead of 15 minutes.
  #
  # @return [Order] all orders in 'in_transit_orders' status that were not checked
  # in the last CHECK_IN_TRANSIT_ORDERS_EVERY hours.
  def self.in_transit_orders
    Order.where(fedex_status_checked_at: nil)
         .or(Order.where('fedex_status_checked_at < ?', CHECK_IN_TRANSIT_ORDERS_EVERY.ago))
         .in_transit
  end

  def self.process_out_for_delivery_orders
    out_for_delivery_orders.each do |order|
      shipment = Fedex::Shipment.find(order.fedex_id)
      order.deliver if shipment.status == 'delivered'
      order.fedex_status_checked_at = Time.now
      order.save
    end
  end

  # @return [Order] all orders in 'out_for_delivery' status
  def self.out_for_delivery_orders
    Order.out_for_delivery
  end
end
