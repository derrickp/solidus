require 'rails_helper'

RSpec.describe Spree::EventBus do
  let(:event_name) { :thing_happened }
  subject { Spree::EventBus.instance }

  context 'subscribing for events' do
    before(:each) do
      subject.clear_subscribers(event_name)
    end
    it 'does not error with subscribe call' do
      subscriber = -> { }
      expect{ subject.subscribe(event_name, subscriber, :call) }.not_to raise_error
      expect(subject.subscriber_count(event_name)).to eq(1)
    end

    it 'only subscribes once' do
      subscriber = -> { }
      subject.subscribe(event_name, subscriber, :call)
      subject.subscribe(event_name, subscriber, :call)
      subject.subscribe(event_name, subscriber, :call)
      subject.subscribe(event_name, subscriber, :call)
      expect(subject.subscriber_count(event_name)).to eq(1)
    end
  end

  context 'publishing an event' do
    let(:event_data) do
      {
        thing_id: 2,
        other_thing_id: 3
      }.freeze
    end

    before(:each) do
      subject.clear_subscribers(event_name)
    end

    it 'does not error with publish call with no subscribers' do
      expect{ subject.publish(event_name, event_data) }.not_to raise_error
    end

    it 'calls subscriber with event data' do
      args = nil
      subscriber = ->(data) { args = data }
      subject.subscribe(event_name, subscriber, :call)

      expect{ subject.publish(event_name, event_data) }.not_to raise_error

      expect(args).to eq(event_data)
    end
  end
end
