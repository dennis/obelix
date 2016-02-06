module Obelix
  module AMI
    class CommandResult
      def initialize(success)
        @success = success
      end

      def success?
        @success
      end

      def success!
        raise "Command failed" unless success?
        self
      end

      def error?
        !success?
      end
    end
  end
end
