require 'singleton'
require 'multi_json/options'

module MultiJson
  class Adapter
    extend Options
    include Singleton
    class << self

      def load(string, options={})
        instance.load(string, collect_load_options(string, options))
      end

      def dump(object, options={})
        instance.dump(object, collect_dump_options(object, options))
      end

    protected

      def collect_load_options(string, options)
        collect_options :load_options, options, [ string, options ]
      end

      def collect_dump_options(object, options)
        collect_options :dump_options, options, [ object, options ]
      end

      def collect_options(method, overrides, args)
        global, local = *[MultiJson, self].map{ |r| r.send(method, *args) }
        global.merge(local).merge(overrides)
      end

    end
  end
end