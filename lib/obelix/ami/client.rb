module Obelix
  module AMI
    class Client
      def initialize(transport: nil, parser: nil)
        @protocol = Protocol.new(transport: transport, parser: parser)

        @responses = {}
        @events = []
        @last_action_id = nil
      end

      def connect(hostname)
        @protocol.connect(hostname)
        self
      end

      def events
        r = @events
        @events = []
        r
      end

      def write(packet)
        @last_action_id = packet['ActionID'].to_s
        @protocol.write(packet)
        @last_action_id
      end

      def read_response
        return nil if @last_action_id.nil?

        while !@responses.has_key?(@last_action_id)
          @protocol.read do |packet|
            if packet.event?
              @events << Event.from_packet(packet)
            else
              @responses[packet['ActionID']] = Response.from_packet(packet)
            end
          end
        end

        response = @responses.delete @last_action_id
        @last_action_id = nil
        response
      end
    end
  end
end
