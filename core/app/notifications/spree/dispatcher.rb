
module Spree
  module Dispatcher
    def self.send_message(name, *args)
      actions = Spree::PermittedMessages::MESSAGES.fetch(name) { Rails.logger.error("Dispatcher: Message #{name} not found, nothing more to do."); return }
      actions.each do |action|
        begin
          action.call(args)
        rescue => exception
          Rails.logger.error("Error sending message to #{action[0]} and method #{action[1]}\n#{exception}")
        end
      end
    end
  end
end
