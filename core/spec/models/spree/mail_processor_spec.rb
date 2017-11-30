require 'rails_helper'

RSpec.describe Spree::MailProcessor do
  let(:observer) { Spree::MailProcessor }
  let(:order) { create(:order) }

  RSpec.shared_examples 'sends the correct email' do |method|
    it 'sends the email' do
      mail_double = double
      expect(mailer).to receive(method).with(*args).and_return(mail_double)
      expect(mail_double).to receive(:deliver_later)
      subject
    end
  end

  describe '#send_confirm_email' do
    subject { observer.send_confirm_email(order.id) }
    include_examples 'sends the correct email', :confirm_email do
      let(:mailer) { Spree::Config.order_mailer_class }
      let(:args) { [order] }
    end

    it 'sets confirmation delivered' do
      expect(order.confirmation_delivered?).to be false
      subject
      expect(order.confirmation_delivered?).to be true
    end

    context ':confirm but a confirmation email has already been sent' do
      it 'does not send duplicate confirmation emails' do
        allow(order).to receive_messages(confirmation_delivered?: true)
        expect(Spree::OrderMailer).not_to receive(:confirm_email)
        subject
      end
    end
  end

  describe '#send_cancel_email' do
    subject { observer.send_cancel_email(order.id) }
    include_examples 'sends the correct email', :cancel_email do
      let(:mailer) { Spree::Config.order_mailer_class }
      let(:args) { [order] }
    end
  end

  describe '#send_inventory_cancellation_email' do
    subject { observer.send_inventory_cancellation_email(order.id, []) }

    include_examples 'sends the correct email', :inventory_cancellation_email do
      let(:mailer) { Spree::Config.order_mailer_class }
      let(:args) { [order, []] }
    end
  end

  describe '#send_reimbursement_email' do
    subject { observer.send_reimbursement_email(reimbursement.id) }
    let(:reimbursement) { create(:reimbursement) }

    include_examples 'sends the correct email', :reimbursement_email do
      let(:mailer) { Spree::Config.reimbursement_mailer_class }
      let(:args) { [reimbursement.id] }
    end
  end

  describe '#send_carton_shipped_email' do
    let(:carton) { create(:carton) }
    subject { observer.send_carton_shipped_emails(carton) }
    include_examples 'sends the correct email', :shipped_email do
      let(:mailer) { Spree::Config.carton_shipped_email_class }
      let(:args) { [order: carton.orders.first, carton: carton] }
    end
  end
end

