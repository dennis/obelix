module Obelix
  module AMI
    class ClientActions
      def login(client, username, secret)
        client.write Obelix::AMI::Action.create("Login", {
          "Username" => username,
          "Secret" => secret,
        })
        client.read_response["response"] == "Success"
      end
    end
  end
end
