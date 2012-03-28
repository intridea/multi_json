module MultiJson
  module Engines
    module JsonCommon

      def decode(string, options={})
        string = string.read if string.respond_to?(:read)
        ::JSON.parse(string, :symbolize_keys => options[:symbolize_keys])
      end

      def encode(object, options={})
        object.to_json(process_options(options))
      end

    protected

      def process_options(options={})
        return options if options.empty?
        opts = {}
        opts.merge!(JSON::PRETTY_STATE_PROTOTYPE.to_h) if options.delete(:pretty)
        opts.merge!(options)
      end

    end
  end
end
