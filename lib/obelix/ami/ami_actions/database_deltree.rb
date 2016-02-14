module Obelix
  module AMI
    module AMIActions
      class DatabaseDeltree < Struct.new(:client, :family)
        def execute
          client.write Obelix::AMI::Action.create("command", {
            "command" => "database deltree \"#{family}\"",
          })
          response = client.read_response
          CommandResult.new is_successful? response
        end

        private
          def is_successful?(response)
            response["response"] == "Follows" &&
              (response.packet.unparsed_lines[0].end_with?("database entries removed.\n--END COMMAND--\r\n") ||
               response.packet.unparsed_lines[0] == "Database entries do not exists\n--END COMMAND--\r\n")
          end
      end
    end
  end
end
