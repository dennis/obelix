module Obelix
  module AMI
    class Client
      attr_reader :actions

      def initialize(protocol:, actions:)
        @protocol = protocol
        @actions = actions

        @responses = {}
        @events = []
        @last_action_id = nil

        @protocol.add_event_listener { |packet| @events << Event.from_packet(packet) }
        @protocol.add_response_listener { |packet| @responses[packet['ActionID']] = Response.from_packet(packet) }
      end

      def connect(hostname)
        @protocol.connect(hostname)
        self
      end

      def events
        r = @events
        @events = []
        r
      end

      def write(packet)
        @last_action_id = packet['ActionID'].to_s
        @protocol.write(packet)
        @last_action_id
      end

      def read_response(action_id = nil)
        action_id ||= @last_action_id

        return nil if action_id.nil?

        while !@responses.has_key?(action_id)
          @protocol.read
        end

        raise "No answer for ActionID: #{action_id}" unless @responses.has_key?(action_id)

        @responses.delete action_id
      end

      def login(username, secret)
        @actions.login(self, username, secret)
      end
    end
  end
end
