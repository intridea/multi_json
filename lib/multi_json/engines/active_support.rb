require 'active_support' unless defined?(::ActiveSupport::JSON)

module MultiJson
  module Engines
    class ActiveSupport
      def self.decode(string, options = {})
        hash = ::ActiveSupport::JSON.decode(string)
        options[:symbolize_keys] ? symbolize_keys(hash) : hash
      end
      
      def self.encode(object)
        ::ActiveSupport::JSON.encode(object)
      end
      
      def self.symbolize_keys(hash)
        hash.inject({}){|result, (key, value)|
          new_key = case key
                    when String then key.to_sym
                    else key
                    end
          new_value = case value
                      when Hash then symbolize_keys(value)
                      else value
                      end
          result[new_key] = new_value
          result
        }
      end
    end
  end
end