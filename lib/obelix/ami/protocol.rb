module Obelix
  module AMI
    class Protocol
      def initialize(transport:, parser:)
        @transport = transport || DisconnectedTransport.new
        @parser = parser || AmiParser.new
        @event_listeners = []
        @response_listeners = []
      end

      def add_event_listener(&block)
        @event_listeners << block
      end

      def add_response_listener(&block)
        @response_listeners << block
      end

      def connect(hostname)
        transport.connect(hostname)

        greeting = transport.read

        raise "Timeout while waiting for greeting" if greeting.empty?
        raise "Not asterisk? #{greeting}" unless greeting =~ /Asterisk Call Manager/
      end

      def read
        if (str = transport.read).length > 0
          parser.parse(str).each do |packet|
            if packet.event?
              @event_listeners.each { |callback| callback.call(packet) }
            else
              @response_listeners.each { |callback| callback.call(packet) }
            end
          end
        end

        @transport = DisconnectedTransport.new unless transport.connected?
      end

      def write(packet)
        @transport.write @parser.assemble(packet)
      end

      private
        attr_accessor :parser
        attr_reader :transport
    end
  end
end
