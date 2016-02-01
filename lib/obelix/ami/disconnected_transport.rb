module Obelix
  module AMI
    class DisconnectedTransport
      def connect(hostname)
        raise "Disconnected"
      end

      def write(str)
        raise "Disconnected"
      end

      def read
        raise "Disconnected"
      end
    end
  end
end
