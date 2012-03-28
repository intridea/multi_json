require 'oj' unless defined?(::Oj)

module MultiJson
  module Engines
    # Use the Oj library to encode/decode.
    class Oj
      ParseError = SyntaxError

      ::Oj.default_options = {:mode => :compat}

      def self.decode(string, options = {}) #:nodoc:
        ::Oj.load(string, :symbol_keys => options[:symbolize_keys])
      end

      def self.encode(object, options = {}) #:nodoc:
        ::Oj.dump(object, options)
      end
    end
  end
end
