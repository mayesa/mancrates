require 'rails_helper'

RSpec.describe Orders::SearchService, type: :service do
  let(:acting_user) { double }
  let(:service) { described_class.new(acting_user) }
  let(:form) { OrderSearchForm.new(search_params) }

  before do
    expect(Order).to receive(:all).and_return(order_scope)
  end

  describe '.call' do
    context 'when form#order_id present' do
      let(:search_params) { { order_id: rand(100) } }
      let(:order_scope) { double(where: true) }
      it 'calls orders.where', :aggregate_failures do
        expect(order_scope).to receive(:where).with(id: form.order_id)
        service.call(form)
      end
    end

    context 'when form#from present' do
      let(:search_params) { { from: 2.days.ago.to_date } }
      let(:order_scope) { double(created_after: true) }
      it 'calls orders.where', :aggregate_failures do
        expect(order_scope).to receive(:created_after).with(form.from)
        service.call(form)
      end
    end

    context 'when form#to present' do
      let(:search_params) { { to: 2.days.ago.to_date } }
      let(:order_scope) { double(created_before: true) }
      it 'calls orders.where', :aggregate_failures do
        expect(order_scope).to receive(:created_before).with(form.to)
        service.call(form)
      end
    end

    context 'when form#statuses present' do
      let(:search_params) { { statuses: ['processing', 'delivered'] } }
      let(:order_scope) { double(in_status: true) }
      it 'calls orders.where', :aggregate_failures do
        expect(order_scope).to receive(:in_status).with(form.statuses)
        service.call(form)
      end
    end
  end
end
