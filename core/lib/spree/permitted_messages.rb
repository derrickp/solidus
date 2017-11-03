module Spree
  # Spree::PermittedMessages contains the messages permitted to be sent to the
  # `Spree::Dispatcher`. Extensions and stores that need additional events to be
  # accepted can mutate these arrays to add them.
  module PermittedMessages
    MESSAGES = {
      carton_shipped: [->(*args) { Spree::Config.carton_shipped_email_class.shipped_email(args) } ],
      order_canceled: [->(*args) { Spree::OrderMailer.cancel_email(args) }],
      order_confirmed: [->(*args) { Spree::OrderMailer.confirm_email(args) }],
      order_inventory_canceled: [->(*args) { Spree::OrderMailer.inventory_cancellation_email(args) }],
      reimbursement_processed: [->(*args) { Spree::ReimbursementMailer.reimbursement_email(args) }]
    }

    mattr_reader(MESSAGES)
  end
end
