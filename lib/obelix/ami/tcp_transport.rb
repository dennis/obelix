module Obelix
  module AMI
    class TCPTransport
      def connect(hostname, username, secret)
        host, port = hostname.split ':'
        port = port.to_i unless port.nil?

        @sock = TCPSocket.open(host, port || 5038)

        self
      end

      def write(str)
        @sock.write str
      end

      def read
        str = ''

        if IO::select([@sock], nil, nil, 1000)
          begin
            str += @sock.readpartial(4096)
          end while IO::select([@sock], nil, nil, 0)
        end

        str
      end
    end
  end
end

