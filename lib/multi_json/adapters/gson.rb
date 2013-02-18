require 'gson' unless defined?(::Gson)
require 'multi_json/adapter'

module MultiJson
  module Adapters
    # Use the gson.rb library to dump/load.
    class Gson < Adapter
      ParseError = ::Gson::DecodeError

      def load(string, options={}) #:nodoc:
        ::Gson::Decoder.new(options).decode(string)
      end

      def dump(object, options={}) #:nodoc:
        ::Gson::Encoder.new(options).encode(object)
      end
    end
  end
end
