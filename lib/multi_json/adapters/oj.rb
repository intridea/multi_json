require 'oj' unless defined?(::Oj)

module MultiJson
  module Adapters
    # Use the Oj library to dump/load.
    class Oj
      ParseError = SyntaxError

      ::Oj.default_options = {:mode => :compat}

      def self.load(string, options={}) #:nodoc:
        ::Oj.load(string, :symbol_keys => options[:symbolize_keys])
      end

      def self.dump(object, options={}) #:nodoc:
        ::Oj.dump(object, options)
      end
    end
  end
end
