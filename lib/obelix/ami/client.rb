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

      def read_response
        return nil if @last_action_id.nil?

        @protocol.read if !@responses.has_key?(@last_action_id)

        raise "No answer for ActionID: #{@last_action_id}" unless @responses.has_key?(@last_action_id)

        response = @responses.delete @last_action_id
        @last_action_id = nil
        response
      end

      def login(username, secret)
        @actions.login(self, username, secret)
      end
    end
  end
end
