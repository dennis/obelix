module Obelix
  module AMI
    EOM = "\r\n\r\n"
    EOL = "\r\n"

    def self.client(hostname)
      Client.new(transport: TCPTransport.new).connect(hostname)
    end
  end
end
