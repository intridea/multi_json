require 'jrjackson' unless defined?(::JrJackson::Json)

module MultiJson
  module Adapters
    # Use the Oj library to dump/load.
    class JrJackson

      def self.load(string, options={}) #:nodoc:
        ::JrJackson::Json.parse(string)
      end

      def self.dump(object, options={}) #:nodoc:
        ::JrJackson::Json.generate(object)
      end
    end
  end
end
