require "multi_json/adapter"

module MultiJson
  module Adapters
    class JsonCommon < Adapter
      defaults :load, create_additions: false, quirks_mode: true

      def load(string, options = {})
        string = string.dup.force_encoding(::Encoding::ASCII_8BIT) if string.respond_to?(:force_encoding)

        options[:symbolize_names] = true if options.delete(:symbolize_keys)
        ::JSON.parse(string, options)
      end

      def dump(object, options = {})
        if options.delete(:pretty)
          options.merge!({
            indent: '  ',
            space: ' ',
            object_nl: "\n",
            array_nl: "\n",
          })
        end

        object.to_json(options)
      end
    end
  end
end
