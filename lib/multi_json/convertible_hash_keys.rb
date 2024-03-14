module MultiJson
  module ConvertibleHashKeys
    private

    def symbolize_keys(hash)
      prepare_hash(hash) do |key|
        key.respond_to?(:to_sym) ? key.to_sym : key
      end
    end

    def stringify_keys(hash)
      prepare_hash(hash) do |key|
        key.respond_to?(:to_s) ? key.to_s : key
      end
    end

    def prepare_hash(hash, &key_modifier)
      return handle_simple_objects(hash) unless hash.is_a?(Array) || hash.is_a?(Hash)
      return handle_array(hash, &key_modifier) if hash.is_a?(Array)

      handle_hash(hash, &key_modifier)
    end

    def handle_simple_objects(obj)
      return obj if simple_object?(obj) || obj.respond_to?(:to_json)

      obj.respond_to?(:to_s) ? obj.to_s : obj
    end

    def handle_array(array, &key_modifier)
      array.map { |value| prepare_hash(value, &key_modifier) }
    end

    def handle_hash(original_hash, &key_modifier)
      original_hash.each_with_object({}) do |(key, value), result|
        modified_key = yield(key)
        result[modified_key] = prepare_hash(value, &key_modifier)
      end
    end

    def simple_object?(obj)
      obj.is_a?(String) || obj.is_a?(Numeric) || obj == true || obj == false || obj.nil?
    end
  end
end
