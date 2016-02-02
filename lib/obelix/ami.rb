module Obelix
  module AMI
    EOM = "\r\n\r\n"
    EOL = "\r\n"

    def self.client(hostname)
      Client.new(protocol: Protocol.new(transport: TCPTransport.new, parser: AmiParser.new)).connect(hostname)
    end
  end
end
