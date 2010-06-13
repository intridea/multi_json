require 'json' unless defined?(::JSON)

module XToJson
  module Engines
    class JsonGem
      def self.decode(string, options = {})
        opts = {}
        opts[:symbolize_names] = options[:symbolize_keys]
        ::JSON.parse(string, opts)
      end
      
      def self.encode(object)
        object.to_json
      end
    end
  end
end