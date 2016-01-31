module Obelix
  module AMI
    class Client
      def initialize(transport: nil, parser: nil)
        @transport = transport || DisconnectedTransport.new
        @parser = parser || AmiParser.new

        @responses = {}
        @events = []
        @last_action_id = nil
      end

      def connect(hostname, username, secret)
        transport.connect(hostname, username, secret)

        greeting = transport.read

        raise "Not asterisk? #{greeting}" unless greeting =~ /Asterisk Call Manager/

        self
      end

      def read
        if (str = transport.read).length > 0
          parser.parse(str) do |packet|
            if packet.event?
              @events << Event.from_packet(packet)
            else
              @responses[packet['ActionID']] = Response.from_packet(packet)
            end
          end
        end

        nil
      end

      def read_response
        return nil if @last_action_id.nil?

        while !@responses.has_key?(@last_action_id)
          read
        end

        response = @responses.delete @last_action_id
        @last_action_id = nil
        response
      end

      def write(packet)
        @last_action_id = packet['ActionID'].to_s

        @transport.write @parser.assemble(packet)

        @last_action_id
      end
      end

      private
        attr_accessor :parser
        attr_reader :transport
    end
  end
end
