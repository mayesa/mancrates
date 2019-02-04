class UpdateShippingStatusJob < ApplicationJob
  queue_as :default

  def perform
    Orders::UpdateShippingStatusService.call
  end
end
