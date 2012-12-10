require 'multi_json/vendor/okjson'

module MultiJson
  module Adapters
    class OkJson
      ParseError = ::MultiJson::OkJson::Error

      def self.load(string, options={}) #:nodoc:
        string = string.read if string.respond_to?(:read)
        result = ::MultiJson::OkJson.decode("[#{string}]").first
        options[:symbolize_keys] ? symbolize_keys(result) : result
      end

      def self.dump(object, options={}) #:nodoc:
        ::MultiJson::OkJson.valenc(stringify_keys(object))
      end

      def self.symbolize_keys(object) #:nodoc:
        modify_keys(object) do |key|
          key.is_a?(String) ? key.to_sym : key
        end
      end

      def self.stringify_keys(object) #:nodoc:
        modify_keys(object) do |key|
          key.respond_to?(:to_s) ? key.to_s : key
        end
      end

      def self.modify_keys(object, &modifier) #:nodoc:
        case object
        when Array
          object.map do |value|
            modify_keys(value, &modifier)
          end
        when Hash
          object.inject({}) do |result, (key, value)|
            new_key   = modifier.call(key)
            new_value = modify_keys(value, &modifier)
            result.merge! new_key => new_value
          end
        else
          object
        end
      end
    end
  end
end
