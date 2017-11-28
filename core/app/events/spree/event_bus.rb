
module Spree
  module EventBus

    class << self
      def publish(name, data)
        puts "#{name} received at #{Time.now}"
      end
    end
  end
end
