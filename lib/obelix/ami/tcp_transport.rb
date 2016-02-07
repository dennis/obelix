module Obelix
  module AMI
    class TCPTransport
      def initialize
        @connected = false
      end

      def connect(hostname)
        host, port = hostname.split ':'
        port = port.to_i unless port.nil?

        @sock = TCPSocket.open(host, port || 5038)
        @connected = true

        self
      end

      def write(str)
        @sock.write str
      end

      def read
        str = ''

        begin
          if IO::select([@sock], nil, nil, 30)
            begin
              str += @sock.readpartial(4096)
            end while IO::select([@sock], nil, nil, 0)
          end
        rescue EOFError
          @connected = false
        end

        str
      end

      def connected?
        @connected
      end
    end
  end
end

