module Obelix
  module AMI
    class DisconnectedTransport
      def connect(_hostname)
        raise "Disconnected"
      end

      def write(_str)
        raise "Disconnected"
      end

      def read
        raise "Disconnected"
      end

      def connected?
        false
      end
    end
  end
end
