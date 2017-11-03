require 'rails_helper'

module TestMailer
  class << self
    attr_accessor :no_args_called
    attr_accessor :args

    def no_args
      @no_args_called = true
    end

    def with_args(args)
      @args = args
    end
  end
end

RSpec.describe Spree::Dispatcher do
  describe '#send_message' do
    context 'message is sent with no configuration existing' do
      it 'does not fail hard' do
        expect{Spree::Dispatcher.send_message(:completely_fake_message_name)}.not_to raise_error
      end
    end

    context 'message with no extra arguments' do
      before do
        Spree::PermittedMessages::MESSAGES[:test_no_args] = [['TestMailer', 'no_args']]
        TestMailer.no_args_called = false
      end

      it 'sends to configured receivers' do
        expect{Spree::Dispatcher.send_message(:test_no_args)}.not_to raise_error
        expect(TestMailer.no_args_called).to eq true
      end
    end

    context 'message with arguments' do
      before do
        Spree::PermittedMessages::MESSAGES[:test_args] = [['TestMailer', 'with_args']]
        TestMailer.args = nil
      end

      it 'sends along arguments to receivers' do
        expect{Spree::Dispatcher.send_message(:test_args, 2)}.not_to raise_error
        expect(TestMailer.args).to eq 2
      end

      context 'receiver does not accept arguments' do
        before do
          Spree::PermittedMessages::MESSAGES[:test_args] = [['TestMailer', 'no_args']]
          TestMailer.no_args_called = false
        end

        it 'still calls receiver' do
          expect{Spree::Dispatcher.send_message(:test_args, 2)}.not_to raise_error
          expect(TestMailer.no_args_called).to eq true
        end
      end

      context 'multiple receivers' do
        before do
          Spree::PermittedMessages::MESSAGES[:test_args] = [['TestMailer', 'with_args'],['TestMailer','no_args']]
          TestMailer.args = nil
          TestMailer.no_args_called = false;
        end

        it 'calls both receivers' do
          expect{Spree::Dispatcher.send_message(:test_args, 2)}.not_to raise_error
          expect(TestMailer.args).to eq 2
          expect(TestMailer.no_args_called).to eq true
        end
      end
    end
  end
end
