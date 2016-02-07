module Obelix
  module AMI
    class DatabaseShowCommandResult
      include Enumerable

      def initialize(response)
        @response = response
      end

      def success?
        @response["response"] == "Follows"
      end

      def success!
        raise "Command failed" unless success?
        self
      end

      def error?
        !success?
      end

      def each
        v = @response.packet.unparsed_lines.join.split("\n")
        v.pop # --END COMMAND--\r
        v.pop # x results found.
        v.each do |l|
          family_key, value = l.split(': ', 2)
          family_key.strip!
          value.strip!

          _, family, key = family_key.split('/')

          yield family, key, value
        end
      end
    end
  end
end
