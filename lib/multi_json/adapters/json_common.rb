module MultiJson
  module Adapters
    module JsonCommon
      DEFAULT_OPTS = {:quirks_mode => true}

      def load(string, options={})
        string = string.read if string.respond_to?(:read)
        ::JSON.parse(string, DEFAULT_OPTS.merge(:symbolize_names => options[:symbolize_keys]))
      end

      def dump(object, options={})
        ::JSON.generate(object, DEFAULT_OPTS.merge(process_options!(options)))
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
