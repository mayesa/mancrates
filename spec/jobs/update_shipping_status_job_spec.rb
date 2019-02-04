require 'rails_helper'

RSpec.describe UpdateShippingStatusJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { described_class.perform_later }

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in default queue' do
    expect(UpdateShippingStatusJob.new.queue_name).to eq('default')
  end

  it 'executes perform' do
    expect(Orders::UpdateShippingStatusService).to receive(:call)
    perform_enqueued_jobs { job }
  end
end
