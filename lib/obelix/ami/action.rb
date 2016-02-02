module Obelix
  module AMI
    class Action
      attr_reader :packet

      def self.from_packet(packet)
        new(packet)
      end

      def self.action_id
        @@action_id ||= 0
        @@action_id += 1
        @@action_id
      end

      def self.create(action, options = {})
        new(Packet.new({
          "Action" => action,
          "ActionID" => self.action_id,
        }.merge(options)))
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
        false
      end
    end
  end
end
