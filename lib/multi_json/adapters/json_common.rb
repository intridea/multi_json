module MultiJson
  module Adapters
    module JsonCommon
      def load(string, options={})
        string = string.read if string.respond_to?(:read)
        ::JSON.parse("[#{string}]", process_options!(options)).first
      end

      def dump(object, options={})
        ::JSON.generate([object], process_options!(options)).strip[1..-2]
      end

    protected

      def process_options!(options={})
        return options if options.empty?
        opts = {}
        opts.merge!(:symbolize_names => true) if options.delete(:symbolize_keys)
        opts.merge!(::JSON::PRETTY_STATE_PROTOTYPE.to_h) if options.delete(:pretty)
        opts.merge!(options)
      end

    end
  end
end
