module Obelix
  module AMI
    class Protocol
      def initialize(transport:, parser:)
        @transport = transport || DisconnectedTransport.new
        @parser = parser || AmiParser.new
      end

      def connect(hostname)
        transport.connect(hostname)

        greeting = transport.read

        raise "Not asterisk? #{greeting}" unless greeting =~ /Asterisk Call Manager/
      end

      def read
        if (str = transport.read).length > 0
          parser.parse(str) do |packet|
            yield packet
          end
        end

        nil
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
