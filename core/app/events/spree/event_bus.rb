
module Spree
  module EventBus

    class << self
      def publish(name, data)
        puts name
      end
    end
  end
end
