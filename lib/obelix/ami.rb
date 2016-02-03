module Obelix
  module AMI
    EOM = "\r\n\r\n"
    EOL = "\r\n"

    def self.client(hostname)
      protocol = Protocol.new(transport: TCPTransport.new, parser: AmiParser.new)
      actions = ClientActions.new
      Client.new(protocol: protocol, actions: actions).connect(hostname)
    end
  end
end
