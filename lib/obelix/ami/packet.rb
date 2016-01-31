module Obelix
  module AMI
    class Packet
      def initialize(options = {})
        @hash = {}

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
    end
  end
end
