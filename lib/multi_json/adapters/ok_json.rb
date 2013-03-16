require 'multi_json/adapters/thick_adapter'
require 'multi_json/vendor/okjson'

module MultiJson
  module Adapters
    class OkJson < ThickAdapter
      ParseError = ::MultiJson::OkJson::Error

      private

      def load_json(string)
        ::MultiJson::OkJson.decode("[#{string}]").first
      end

      def dump_json(object)
        ::MultiJson::OkJson.valenc(object)
      end
    end
  end
end
