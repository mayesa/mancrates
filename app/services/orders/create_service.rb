class Orders::CreateService < ApplicationService
  def call(params)
    Order.create(params)
  end
end
