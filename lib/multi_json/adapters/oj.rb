require 'oj' unless defined?(::Oj)

module MultiJson
  module Adapters
    # Use the Oj library to dump/load.
    class Oj
      DEFAULT_OPTIONS = {:mode => :compat}.freeze

      ParseError = if defined?(::Oj::ParseError)
        ::Oj::ParseError
      else
        SyntaxError
      end

      def self.load(string, options={}) #:nodoc:
        options.merge!(:symbol_keys => options[:symbolize_keys])
        ::Oj.load(string, DEFAULT_OPTIONS.merge(options))
      end

      def self.dump(object, options={}) #:nodoc:
        options.merge!(:indent => 2) if options[:pretty]
        ::Oj.dump(object, DEFAULT_OPTIONS.merge(options))
      end
    end
  end
end
