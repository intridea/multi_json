module MultiJson
  module_function
  
  # Get the current engine class.
  def engine
    return @engine if @engine
    self.engine = self.default_engine
    @engine
  end
  
  # The default engine based on what you currently
  # have loaded. Tries Yajl first, then JSON gem,
  # then ActiveSupport and JSON pure.
  def default_engine
    return :yajl if defined?(::Yajl)
    return :json_gem if defined?(::JSON)
    return :active_support if defined?(::ActiveSupport::JSON)
    :json_pure
  end
  
  # Set the JSON parser utilizing a symbol, string, or class.
  # Supported by default are:
  #
  # * <tt>:json_gem</tt>
  # * <tt>:json_pure</tt>
  # * <tt>:active_support</tt> (useful for inside Rails apps)
  # * <tt>:yajl</tt>
  def engine=(new_engine)
    case new_engine
      when String, Symbol
        require "multi_json/engines/#{new_engine}"
        @engine = MultiJson::Engines.const_get("#{new_engine.to_s.split('_').map{|s| s.capitalize}.join('')}")
      when Class
        @engine = new_engine
      else
        raise "Did not recognize your engine specification. Please specify either a symbol or a class."
    end
  end
  
  # Decode a JSON string into Ruby.
  #
  # <b>Options</b>
  #
  # <tt>:symbolize_keys</tt> :: If true, will use symbols instead of strings for the keys.
  def decode(string, options = {})
    engine.decode(string, options)
  end
  
  # Encodes a Ruby object as JSON.
  def encode(object)
    engine.encode(object)
  end
end