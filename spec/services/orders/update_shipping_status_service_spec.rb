require 'rails_helper'

RSpec.describe Orders::UpdateShippingStatusService, type: :service do
  let(:service) { described_class }

  describe '.call' do
    context 'awaiting_pickup_orders' do
      let!(:awaiting_pickup_order_a) { create(:awaiting_pickup_order, fedex_status_checked_at: 13.hours.ago) }
      let!(:awaiting_pickup_order_b) { create(:awaiting_pickup_order, fedex_status_checked_at: 13.hours.ago) }
      let!(:awaiting_pickup_order_c) { create(:awaiting_pickup_order, fedex_status_checked_at: 11.hours.ago) }
      let(:fedex_in_transit_shipment) { instance_double(Fedex::Shipment, status: 'in_transit') }
      let(:fedex_awaiting_pickup_shipment) { instance_double(Fedex::Shipment, status: 'awaiting_pickup') }

      before do
        expect(Fedex::Shipment).to receive(:find)
          .with(awaiting_pickup_order_a.fedex_id).and_return(fedex_in_transit_shipment)
        expect(Fedex::Shipment).to receive(:find)
          .with(awaiting_pickup_order_b.fedex_id).and_return(fedex_awaiting_pickup_shipment)
        expect(Fedex::Shipment).to_not receive(:find)
          .with(awaiting_pickup_order_c.fedex_id)
      end

      it 'updates awaiting_pickup_orders accordingly', :aggregate_failures do
        service.call
        expect(awaiting_pickup_order_a.reload.in_transit?).to eq true
        expect(awaiting_pickup_order_b.reload.awaiting_pickup?).to eq true
        expect(awaiting_pickup_order_c.reload.awaiting_pickup?).to eq true
      end
    end

    context 'in_transit_orders_orders' do
      let!(:in_transit_order_a) { create(:in_transit_order, fedex_status_checked_at: 7.hours.ago) }
      let!(:in_transit_order_b) { create(:in_transit_order, fedex_status_checked_at: 7.hours.ago) }
      let!(:in_transit_order_c) { create(:in_transit_order, fedex_status_checked_at: 5.hours.ago) }
      let(:fedex_out_for_delivery_shipment) { instance_double(Fedex::Shipment, status: 'out_for_delivery') }
      let(:fedex_in_transit_shipment) { instance_double(Fedex::Shipment, status: 'awaiting_pickup') }

      before do
        expect(Fedex::Shipment).to receive(:find)
          .with(in_transit_order_a.fedex_id).and_return(fedex_out_for_delivery_shipment).twice
        expect(Fedex::Shipment).to receive(:find)
          .with(in_transit_order_b.fedex_id).and_return(fedex_in_transit_shipment)
        expect(Fedex::Shipment).to_not receive(:find)
          .with(in_transit_order_c.fedex_id)
      end

      it 'updates in_transit_orders accordingly', :aggregate_failures do
        service.call
        expect(in_transit_order_a.reload.out_for_delivery?).to eq true
        expect(in_transit_order_b.reload.in_transit?).to eq true
        expect(in_transit_order_c.reload.in_transit?).to eq true
      end
    end

    context 'out_for_delivery orders' do
      let!(:out_for_delivery_order_a) { create(:out_for_delivery_order, fedex_status_checked_at: 1.hours.ago) }
      let!(:out_for_delivery_order_b) { create(:out_for_delivery_order, fedex_status_checked_at: 2.hours.ago) }
      let(:fedex_delivered) { instance_double(Fedex::Shipment, status: 'delivered') }
      let(:fedex_out_for_delivery_shipment) { instance_double(Fedex::Shipment, status: 'out_for_delivery') }

      before do
        expect(Fedex::Shipment).to receive(:find)
          .with(out_for_delivery_order_a.fedex_id).and_return(fedex_delivered)
        expect(Fedex::Shipment).to receive(:find)
          .with(out_for_delivery_order_b.fedex_id).and_return(fedex_out_for_delivery_shipment)
      end

      it 'updates delivered_pickup_orders accordingly', :aggregate_failures do
        service.call
        expect(out_for_delivery_order_a.reload.delivered?).to eq true
        expect(out_for_delivery_order_b.reload.out_for_delivery?).to eq true
      end
    end
  end
end
