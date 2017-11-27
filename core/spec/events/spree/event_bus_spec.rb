require 'rails_helper'

RSpec.describe Spree::EventBus do
  context 'publishing an event' do
    let(:event_name) { :thing_happened }
    let(:event_data) do
      {
        thing_id: 2,
        other_thing_id: 3
      }.freeze
    end

    it 'does not error with publish call' do
      expect{ Spree::EventBus.publish(event_name, event_data) }.not_to raise_error

    end
  end
end
