module MultiJson
  module OptionsCache
    extend self

    def reset
      @dump_cache = {}
      @load_cache = {}
    end

    def fetch(type, key)
      cache = instance_variable_get("@#{type}_cache")
      cache.key?(key) ? cache[key] : cache[key] = yield
    end
  end
end
