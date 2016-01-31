module Obelix
  module AMI
    class AmiParser
      def initialize
        @buffer = ''
      end

      def parse(string)
        @buffer += string

        pos = @buffer.index(EOM)
        while !pos.nil?
          message = @buffer[0, pos]
          @buffer = @buffer[pos + EOM.length, @buffer.length - pos]

          yield parse_message(message)

          pos = @buffer.index(EOM)
        end
      end

      def assemble(packet)
        packet.to_h.map do |key, value|
          "#{key}: #{value}"
        end.join(EOL) + EOM
      end

      private
        def parse_message(message)
          packet = Packet.new

          message.split(EOL).each do |line|
            key, value = line.split(':', 2)

            packet[key] = value.strip
          end

          if packet['Event']
            Event.from_packet(packet)
          else
            Response.from_packet(packet)
          end
        end
    end
  end
end
