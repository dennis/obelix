module Obelix
  module AMI
    class Response
      attr_reader :packet

      def self.from_packet(packet)
        new(packet)
      end

      def initialize(packet)
        @packet = packet
      end

      def [](key)
        @packet[key]
      end

      def to_h
        @packet.to_h
      end

      def event?
        false
      end

      def response?
        true
      end
    end
  end
end
