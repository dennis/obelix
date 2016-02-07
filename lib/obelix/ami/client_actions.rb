module Obelix
  module AMI
    class ClientActions
      def login(client, username, secret)
        AMIActions::Login.new(client, username, secret).execute
      end

      end
      end
    end
  end
end
