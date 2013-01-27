module MultiJson
  module Adapters
    module JsonCommon
      def load(string, options={})
        string = string.read if string.respond_to?(:read)
        ::JSON.parse("[#{string}]", {:symbolize_names => options[:symbolize_keys]}).first
      end

      def dump(object, options={})
        ::JSON.generate([object], process_options!(options)).strip[1..-2]
      end

    protected

      def process_options!(options={})
        return options if options.empty?
        opts = {}
        opts.merge!(::JSON::PRETTY_STATE_PROTOTYPE.to_h) if options.delete(:pretty)
        opts.merge!(options)
      end

    end
  end
end
