require 'rails_helper'

$called = false
RSpec.describe Spree::Observable do

  context 'pure observable' do
    subject { Spree::Observable.new }
    let(:observer) { ->(*args) { $called = true } }

    it 'will exist' do
      expect(subject).not_to eq(nil)
    end

    it 'can handle having notify_observers called without adding an observer' do
      expect{ subject.notify_observers }.not_to raise_error
    end

    it 'has 0 observers' do
      expect(subject.count_observers).to eq 0
    end

    context 'add observers' do
      before do
        subject.add_observer(observer, :call)
      end

      after do
        subject.delete_observers
      end

      it 'has 1 observer' do
        expect(subject.count_observers).to eq(1)
      end
    end

    context 'observers are notified' do
      before do
        $called = false
        subject.add_observer(observer, :call)
        subject.notify_observers
      end

      after do
        $called = false
        subject.delete_observers
      end

      it 'observer has been called' do
        expect($called).to eq(true)
      end

      context 'notify_observers called with args' do
        before do
          subject.delete_observers
        end
        after do
          subject.delete_observers
        end
        it 'observer gets args' do
          received_args = nil
          obs = ->(args) { received_args = args }
          subject.add_observer(obs, :call)
          subject.notify_observers(1)
          expect(received_args).to eq(1)
        end
      end

      context 'multiple observers' do
        before do
          subject.delete_observers
        end

        after do
          subject.delete_observers
        end

        it 'all are notified' do
          called1 = false
          called2 = false
          observer1 = -> { called1 = true }
          observer2 = -> { called2 = true }

          subject.add_observer(observer1, :call)
          subject.add_observer(observer2, :call)
          subject.notify_observers

          expect(called1).to eq(true)
          expect(called2).to eq(true)
        end
      end
    end
  end

end
