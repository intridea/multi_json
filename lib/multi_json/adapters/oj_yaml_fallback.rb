require 'multi_json/adapters/oj'
require 'multi_json/adapters/yaml'

module MultiJson
  module Adapters
    # Try to use Oj to parse JSON. Fallback on Yaml on error.
    class OjYamlFallback
      class ParseError < RuntimeError; end

      class << self
        # A lambda that gets called if Oj fails to parse a json string but Yaml
        # succeeds. This is meant to collect information about who is sending us
        # invalid JSON
        attr_accessor :error_callback
      end

      ADAPTERS = [MultiJson::Adapters::Oj, MultiJson::Adapters::Yaml].freeze

      def self.load(string, options={}) 
        success = false
        adapters = ADAPTERS.dup
        has_failure = false
        parsed_json = nil
        while !success && adapter = adapters.shift
          begin
            parsed_json = adapter.load(string, options)
          rescue adapter::ParseError
            has_failure = true
          else
            success = true
          end
        end
        raise ParseError.new($!) if parsed_json.nil?
        error_callback.call(string) if error_callback && has_failure
        parsed_json
      end

      def self.dump(object, options={})
        MultiJson::Adapters::Oj.dump(object, options)
      end
    end
  end
end
