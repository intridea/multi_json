module MultiJson
  class DecodeError < StandardError
    attr_reader :data
    def initialize(message, backtrace, data)
      super(message)
      self.set_backtrace(backtrace)
      @data = data
    end
  end

  module_function

  @adapter = nil

  REQUIREMENT_MAP = [
    ["oj", :oj],
    ["yajl", :yajl],
    ["json", :json_gem],
    ["json/pure", :json_pure]
  ]

  # TODO: Remove for 2.0 release (but no sooner)
  def default_engine
    deprecate("MultiJson.default_engine is deprecated and will be removed in the next major version. Use MultiJson.default_adapter instead.")
    self.default_adapter
  end

  # The default adapter based on what you currently
  # have loaded and installed. First checks to see
  # if any adapters are already loaded, then checks
  # to see which are installed if none are loaded.
  def default_adapter
    return :oj if defined?(::Oj)
    return :yajl if defined?(::Yajl)
    return :json_gem if defined?(::JSON)

    REQUIREMENT_MAP.each do |(library, adapter)|
      begin
        require library
        return adapter
      rescue LoadError
        next
      end
    end

    Kernel.warn "[WARNING] MultiJson is using the default adapter (ok_json). We recommend loading a different JSON library to improve performance."
    :ok_json
  end

  # TODO: Remove for 2.0 release (but no sooner)
  def engine
    deprecate("MultiJson.engine is deprecated and will be removed in the next major version. Use MultiJson.adapter instead.")
    self.adapter
  end

  # Get the current adapter class.
  def adapter
    return @adapter if @adapter
    self.use self.default_adapter
    @adapter
  end

  # TODO: Remove for 2.0 release (but no sooner)
  def engine=(new_engine)
    deprecate("MultiJson.engine= is deprecated and will be removed in the next major version. Use MultiJson.use instead.")
    self.use(new_engine)
  end

  # Set the JSON parser utilizing a symbol, string, or class.
  # Supported by default are:
  #
  # * <tt>:oj</tt>
  # * <tt>:json_gem</tt>
  # * <tt>:json_pure</tt>
  # * <tt>:ok_json</tt>
  # * <tt>:yajl</tt>
  # * <tt>:nsjsonserialization</tt> (MacRuby only)
  def use(new_adapter)
    @adapter = load_adapter(new_adapter)
  end
  alias :adapter= :use

  def load_adapter(new_adapter)
    case new_adapter
    when String, Symbol
      require "multi_json/adapters/#{new_adapter}"
      MultiJson::Adapters.const_get("#{new_adapter.to_s.split('_').map{|s| s.capitalize}.join('')}")
    when NilClass
      nil
    when Class
      new_adapter
    else
      raise "Did not recognize your adapter specification. Please specify either a symbol or a class."
    end
  end

  # TODO: Remove for 2.0 release (but no sooner)
  def decode(string, options={})
    deprecate("MultiJson.decode is deprecated and will be removed in the next major version. Use MultiJson.load instead.")
    self.load(string, options)
  end

  # Decode a JSON string into Ruby.
  #
  # <b>Options</b>
  #
  # <tt>:symbolize_keys</tt> :: If true, will use symbols instead of strings for the keys.
  # <tt>:adapter</tt> :: If set, the selected engine will be used just for the call.
  def load(string, options={})
    adapter = current_adapter(options)
    adapter.load(string, options)
  rescue adapter::ParseError => exception
    raise DecodeError.new(exception.message, exception.backtrace, string)
  end

  def current_adapter(options)
    if new_adapter = (options || {}).delete(:adapter)
      load_adapter(new_adapter)
    else
      adapter
    end
  end

  # TODO: Remove for 2.0 release (but no sooner)
  def encode(object, options={})
    deprecate("MultiJson.encode is deprecated and will be removed in the next major version. Use MultiJson.dump instead.")
    self.dump(object, options)
  end

  # Encodes a Ruby object as JSON.
  def dump(object, options={})
    adapter = current_adapter(options)
    adapter.dump(object, options)
  end

  # Sends of a deprecation warning
  def deprecate(raw_message)
    @messages ||= {}
    message = "#{Kernel.caller[1]}: [DEPRECATION] #{raw_message}"
    unless @messages[message]
      @messages[message] = true
      Kernel.warn message
    end
  end
end
