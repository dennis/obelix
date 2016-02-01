module Obelix
  module AMI
    class Packet
      attr_reader :unparsed_lines

      def initialize(options = {})
        @hash = {}
        @unparsed_lines = []

        options.each do |k,v|
          self[k.downcase] = v
        end
      end

      def to_h
        @hash
      end

      def []=(key, value)
        @hash[key.downcase] = value
      end

      def [](key)
        @hash[key.downcase]
      end

      def add_unparsed_line(line)
        @unparsed_lines << line
      end
    end
  end
end
