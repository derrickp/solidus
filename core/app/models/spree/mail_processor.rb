module Spree
  class MailProcessor
    class << self
      def send_confirm_email(order_id)
        order = Spree::Order.find(order_id)
        Spree::Config.order_mailer_class.confirm_email(order).deliver_later unless order.confirmation_delivered?
        order.update_column(:confirmation_delivered, true)
      end

      def send_cancel_email(order_id)
        order = Spree::Order.find(order_id)
        Spree::Config.order_mailer_class.cancel_email(order).deliver_later
      end

      def send_inventory_cancellation_email(order_id, inventory_units)
        order = Spree::Order.find(order_id)
        Spree::Config.order_mailer_class.inventory_cancellation_email(order, inventory_units).deliver_later
      end

      def send_reimbursement_email(id)
        Spree::Config.reimbursement_mailer_class.reimbursement_email(id).deliver_later
      end

      def send_carton_shipped_emails(carton, suppress_mailer)
        return if suppress_mailer
        carton.orders.each do |order|
          Spree::Config.carton_shipped_email_class.shipped_email(order: order, carton: carton).deliver_later if carton.stock_location.fulfillable? # e.g. digital gift cards that aren't actually shipped
        end
      end
    end
  end
end

Spree::Config.event_bus.subscribe(:order_confirmed, Spree::MailProcessor, :send_confirm_email)
Spree::Config.event_bus.subscribe(:order_cancelled, Spree::MailProcessor, :send_cancel_email)
Spree::Config.event_bus.subscribe(:order_inventory_cancelled, Spree::MailProcessor, :order_inventory_cancelled)
Spree::Config.event_bus.subscribe(:reimbursement_processed, Spree::MailProcessor, :send_reimbursement_email)
Spree::Config.event_bus.subscribe(:carton_shipped, Spree::MailProcessor, :send_carton_shipped_emails)
