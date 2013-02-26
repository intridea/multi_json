require 'multi_json/adapter'

module MultiJson
  module Adapters
    class JsonCommon < Adapter
      defaults :load, :create_additions => false

      def load(string, options={})
        string = string.read if string.respond_to?(:read)
        options[:symbolize_names] = true if options.delete(:symbolize_keys)
        ::JSON.parse(string, options)
      end

      def dump(object, options={})
        options.merge!(::JSON::PRETTY_STATE_PROTOTYPE.to_h) if options.delete(:pretty)
        object.to_json(options)
      end
    end
  end
end
