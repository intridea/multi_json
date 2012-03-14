require 'oj' unless defined?(Oj)

module MultiJson
  module Engines
    # Use the Oj library to encode/decode.
    class Oj
      ParseError = SyntaxError

      def self.decode(string, options = {}) #:nodoc:
        ::Oj.load(string, options)
      end

      def self.encode(object, options = {}) #:nodoc:
        ::Oj.dump(object, options)
      end
    end
  end
end
