module Obelix
  module AMI
    class Event
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
        true
      end

      def response?
        false
      end
    end
  end
end
