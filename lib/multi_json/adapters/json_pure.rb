require 'json/pure' unless defined?(::JSON)
require 'multi_json/adapters/json_common'

module MultiJson
  module Adapters
    # Use JSON pure to dump/load.
    class JsonPure < JsonCommon
      ParseError = ::JSON::ParserError

      def self.gem_name
        'json_pure'
      end
    end
  end
end
