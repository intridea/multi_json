require 'json' unless defined?(::JSON)
require 'multi_json/engines/json_common'

module MultiJson
  module Engines
    # Use the JSON gem to dump/load.
    class JsonGem
      ParseError = ::JSON::ParserError
      extend JsonCommon
    end
  end
end
