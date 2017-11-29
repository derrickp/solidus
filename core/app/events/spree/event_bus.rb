module Spree
  class EventBus
    include Singleton

    @@subscriptions = Hash.new { |hash, key| hash[key] = [] }

    def publish(name, data)
      subscription = @@subscriptions[name]
      subscription.each do |subscription_def|
        subscription_def[0].public_send(subscription_def[1], data)
      end
    end

    def subscribe(name, subscriber, call)
      subscription = @@subscriptions[name]
      subscription_def = [subscriber, call]
      contains = subscription.any? { |sub_def| sub_def == subscription_def }
      subscription << subscription_def unless contains
    end

    def subscriber_count(name)
      subscription = @@subscriptions[name]
      subscription.size
    end

    def clear_subscribers(name)
      subscription = @@subscriptions[name]
      subscription.clear
    end
  end
end
