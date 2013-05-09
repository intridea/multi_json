require 'singleton'
require 'multi_json/options'

module MultiJson
  class Adapter
    extend Options
    include Singleton
    class << self

      def defaults(action, value)
        metaclass = class << self; self; end

        metaclass.instance_eval do
          define_method("default_#{action}_options"){ value }
        end
      end

      def activate!
        @load_options_cache = {}
        @dump_options_cache = {}
        instance.activate if instance.respond_to?(:activate)
      end

      def load(string, options={})
        instance.load(string, collect_load_options(string, options).clone)
      end

      def dump(object, options={})
        instance.dump(object, collect_dump_options(object, options).clone)
      end

    protected

      def collect_load_options(string, options)
        @load_options_cache[options] ||= collect_options(:load_options, options).merge(options)
      end

      def collect_dump_options(object, options)
        @dump_options_cache[options] ||= collect_options(:dump_options, options).merge(options)
      end

      def collect_options(method, *args)
        global, local = *[MultiJson, self].map{ |r| r.send(method, *args) }
        local.merge(global)
      end

    end
  end
end
