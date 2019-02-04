class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  def index
    @search_form = OrderSearchForm.new(search_params)
    @orders = Orders::SearchService.build(current_user).call(@search_form)
    @order_statuses = Order.aasm.states.map(&:name)
    @total_orders = @orders.count
  end

  def new
    @order = Order.new
    set_available_products
    set_shipping_methods
  end

  def create
    @order = Orders::CreateService.build(current_user).call(create_params)
    respond_to do |format|
      if @order.valid?
        format.html { redirect_to orders_url, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        set_available_products
        set_shipping_methods
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_available_products
    @available_products = Product.available
  end

  def set_shipping_methods
    @shipping_methods   = Order.shipping_methods
  end

  def create_params
    params.require(:order).permit(:product_id, :customer_name, :adress, :zip_code, :shipping_method)
  end

  def search_params
    params.require(:order_search_form).permit(:order_id, :from, :to, statuses: [])
  end
end
