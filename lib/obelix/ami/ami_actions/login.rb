module Obelix
  module AMI
    module AMIActions
      class Login < Struct.new(:client, :username, :secret)
        def execute
          client.write Obelix::AMI::Action.create("Login", {
            "Username" => username,
            "Secret" => secret,
          })
          CommandResult.new(client.read_response["response"] == "Success")
        end
      end
    end
  end
end
