
module Spree
  module Dispatcher
    def self.send_message(name, *args)
      actions = Spree::PermittedMessages::MESSAGES.fetch(name) { Rails.logger.error("Dispatcher: Message #{name} not found, nothing more to do."); return }
      actions.each do |action|
        begin
          method_name = action[1]
          action_class = Object.const_get(action[0])
          instance = action_class.respond_to?(method_name) ? action_class : action_class.new
          next unless instance.respond_to?(method_name)
          if instance.method(method_name).arity == 0
            instance.public_send(method_name)
          else
            instance.public_send(method_name, *args)
          end
        rescue => exception
          Rails.logger.error("Error sending message to #{action[0]} and method #{action[1]}\n#{exception}")
        end
      end
    end
  end
end
