
module Spree
  module EventBus

    class << self
      def publish(name, data)
        puts "#{name} received with #{data} at #{Time.now}"
      end
    end
  end
end
