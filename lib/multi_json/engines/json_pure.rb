require 'json/pure' unless defined?(::JSON)
require 'multi_json/engines/json_common'

module MultiJson
  module Engines
    # Use JSON pure to dump/load.
    class JsonPure
      ParseError = ::JSON::ParserError
      extend JsonCommon
    end
  end
end
