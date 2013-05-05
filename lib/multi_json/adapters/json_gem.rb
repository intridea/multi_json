require 'json' unless defined?(::JSON)
require 'multi_json/adapters/json_common'

module MultiJson
  module Adapters
    # Use the JSON gem to dump/load.
    class JsonGem < JsonCommon
      ParseError = ::JSON::ParserError

      def self.gem_name
        'json'
      end
    end
  end
end
