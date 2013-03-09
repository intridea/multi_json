require 'jrjackson_r' unless defined?(::JrJackson)
require 'multi_json/adapters/ok_json'

module MultiJson
  module Adapters
    class Jrjackson < MultiJson::Adapters::OkJson
      ParseError = ::Java::OrgCodehausJackson::JsonParseException

      def load(string, options={}) #:nodoc:
        string = string.read if string.respond_to?(:read)
        result = ::JrJackson::Json.parse(string)
        options[:symbolize_keys] ? symbolize_keys(result) : result
      end

      def dump(object, options={}) #:nodoc:
        ::JrJackson::Json.generate(prepare_object(object){ |value| value })
      end
    end
  end
end
