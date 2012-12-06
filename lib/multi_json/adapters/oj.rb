require 'oj' unless defined?(::Oj)

module MultiJson
  module Adapters
    # Use the Oj library to dump/load.
    class Oj
      ParseError = if defined?(::Oj::ParseError)
        ::Oj::ParseError
      else
        SyntaxError
      end

      ::Oj.default_options = {:mode => :compat}

      def self.stringify_keys(object)
        case object
        when Hash
          object.inject({}) do |memo, (k,v)|
            memo[k.to_s] = stringify_keys(v)
            memo
          end
        when Array
          object.map(&method(:stringify_keys))
        else
          object
        end
      end

      def self.load(string, options={}) #:nodoc:
        options.merge!(:symbol_keys => options[:symbolize_keys])
        ::Oj.load(string, options)
      end

      def self.dump(object, options={}) #:nodoc:
        options.merge!(:indent => 2) if options[:pretty]
        ::Oj.dump(stringify_keys(object), options)
      end
    end
  end
end
