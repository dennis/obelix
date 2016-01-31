module Obelix
  module AMI
    EOM = "\r\n\r\n"
    EOL = "\r\n"

    def self.client(hostname, username, secret)
      Client.new(transport: TCPTransport.new).connect(hostname, username, secret)
    end
  end
end
