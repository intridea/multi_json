require 'multi_json/adapters/thick_adapter'
require 'multi_json/vendor/okjson'

module MultiJson
  module Adapters
    class OkJson < ThickAdapter
      ParseError = ::MultiJson::OkJson::Error

      private

      def load_json(string) #:nodoc:
        ::MultiJson::OkJson.decode("[#{string}]").first
      end

      def dump_json(object) #:nodoc:
        ::MultiJson::OkJson.valenc(object)
      end
    end
  end
end
