module Obelix
  module AMI
    def self.client(hostname, username, secret)
      Client.new(hostname, username, secret)
    end
  end
end
