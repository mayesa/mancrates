require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe 'GET index' do
    context 'when user logged in' do
      login_user

      let(:search_form) { double }
      let(:search_service) { double }
      let(:total_orders) { rand(100) }
      let(:orders) { double(count: total_orders) }

      before do
        expect(OrderSearchForm).to receive(:new).and_return(search_form)
        expect(Orders::SearchService).to receive(:build).and_return(search_service)
        expect(search_service).to receive(:call).with(search_form).and_return(orders)
      end

      it 'assigns expected variables', :aggregate_failures do
        get :index
        expect(assigns(:search_form)).to eq search_form
        expect(assigns(:orders)).to eq orders
        expect(assigns(:total_orders)).to eq total_orders
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template('index')
      end
    end

    context 'when user not logged in' do
      it 'redirects to new_user_session_url' do
        get :index
        expect(response).to redirect_to(new_user_session_url)
      end
    end
  end

  describe 'GET new' do
    let(:order) { double }
    let(:available_products) { double }
    let(:shipping_methods) { double }

    before do
      expect(Order).to receive(:new).and_return(order)
      expect(Product).to receive(:available).and_return(available_products)
      expect(Order).to receive(:shipping_methods).and_return(shipping_methods)
    end

    it 'assigns expected variables', :aggregate_failures do
      get :new
      expect(assigns(:order)).to eq order
      expect(assigns(:available_products)).to eq available_products
      expect(assigns(:shipping_methods)).to eq shipping_methods
    end
  end

  describe 'POST create' do
    let(:order) { double }
    let(:create_service) { double }
    let(:order_params) { { product_id: rand(100), customer_name: 'Any Name' } }
    let(:post_params) { { order: order_params } }
    let(:service_params) { ActionController::Parameters.new(order_params).permit }
    let(:available_products) { double }
    let(:shipping_methods) { double }

    before do
      expect(Orders::CreateService).to receive(:build).and_return(create_service)
      expect(create_service).to receive(:call).and_return(order)
    end

    context 'when order.valid?' do
      before do
        expect(order).to receive(:valid?).and_return(true)
      end
      it 'redirects to orders_url' do
        post :create, params: post_params
        expect(response).to redirect_to(orders_url)
      end
    end

    context 'when not order.valid?' do
      before do
        expect(order).to receive(:valid?).and_return(false)
        expect(Product).to receive(:available).and_return(available_products)
        expect(Order).to receive(:shipping_methods).and_return(shipping_methods)
      end
      it 'assigns expected variables', :aggregate_failures do
        post :create, params: post_params
        expect(assigns(:order)).to eq order
        expect(assigns(:available_products)).to eq available_products
        expect(assigns(:shipping_methods)).to eq shipping_methods
      end
      it 'renders the new template' do
        post :create, params: post_params
        expect(response).to render_template('new')
      end
    end
  end
end
