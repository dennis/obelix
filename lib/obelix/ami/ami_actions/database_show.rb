module Obelix
  module AMI
    module AMIActions
      class DatabaseShow < Struct.new(:client)
        def execute
          client.write Obelix::AMI::Action.create("command", { "command" => "database show" })
          DatabaseShowCommandResult.new(client.read_response)
        end
      end
    end
  end
end
