module Obelix
  module AMI
    module AMIActions
      class DatabasePut < Struct.new(:client, :family, :key, :value)
        def execute
          client.write Obelix::AMI::Action.create("command", {
            "command" => "database put \"#{family}\" \"#{key}\" \"#{value}\"",
          })
          response = client.read_response
          CommandResult.new(response["response"] == "Follows" && response.packet.unparsed_lines[0] == "Updated database successfully\n--END COMMAND--\r\n")
        end
      end
    end
  end
end
