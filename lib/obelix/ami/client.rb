module Obelix
  module AMI
    class Client
      attr_reader :actions

      def initialize(protocol: TCPTransport.new, actions: AmiParser.new)
        @protocol = protocol
        @actions = actions

        @responses = {}
        @events = []
        @last_action_id = nil

        @protocol.add_event_listener { |event| @events << event }
        @protocol.add_response_listener { |response| @responses[response['ActionID']] = response }
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

      def method_missing(meth, *args, &block)
        meth = meth.to_s
        bang = false

        if meth.to_s[-1] == "!"
          bang=true
          meth=meth[0...-1]
        end

        meth = meth.to_sym

        if @actions.respond_to? meth
          result = @actions.send meth, *([self] + args), &block

          result.success! if bang
          result
        else
          raise NoMethodError
        end
      end
    end
  end
end
