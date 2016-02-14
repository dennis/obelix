module Obelix
  module AMI
    module AMIActions
      class DatabaseDel < Struct.new(:client, :family, :key)
        def execute
          client.write Obelix::AMI::Action.create("command", {
            "command" => "database del \"#{family}\" \"#{key}\"",
          })
          response = client.read_response
          CommandResult.new(response["response"] == "Follows" && response.packet.unparsed_lines[0] == "Database entry removed.\n--END COMMAND--\r\n")
        end
      end
    end
  end
end
