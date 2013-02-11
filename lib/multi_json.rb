module MultiJson
  extend self

  class LoadError < StandardError
    attr_reader :data
    def initialize(message='', backtrace=[], data='')
      super(message)
      self.set_backtrace(backtrace)
      @data = data
    end
  end
  DecodeError = LoadError # Legacy support


  @default_options = {}
  attr_accessor :default_options

  REQUIREMENT_MAP = [
    ['oj',        :oj],
    ['yajl',      :yajl],
    ['json',      :json_gem],
    ['gson',      :gson],
    ['json/pure', :json_pure]
  ]

  # The default adapter based on what you currently
  # have loaded and installed. First checks to see
  # if any adapters are already loaded, then checks
  # to see which are installed if none are loaded.
  def default_adapter
    return :oj if defined?(::Oj)
    return :yajl if defined?(::Yajl)
    return :json_gem if defined?(::JSON)
    return :gson if defined?(::Gson)

    REQUIREMENT_MAP.each do |(library, adapter)|
      begin
        require library
        return adapter
      rescue ::LoadError
        next
      end
    end

    Kernel.warn '[WARNING] MultiJson is using the default adapter (ok_json). We recommend loading a different JSON library to improve performance.'
    :ok_json
  end
  # :nodoc:
  alias :default_engine :default_adapter

  # Get the current adapter class.
  def adapter
    return @adapter if defined?(@adapter) && @adapter

    self.use nil # load default adapter

    @adapter
  end
  # :nodoc:
  alias :engine :adapter

  # Set the JSON parser utilizing a symbol, string, or class.
  # Supported by default are:
  #
  # * <tt>:oj</tt>
  # * <tt>:json_gem</tt>
  # * <tt>:json_pure</tt>
  # * <tt>:ok_json</tt>
  # * <tt>:yajl</tt>
  # * <tt>:nsjsonserialization</tt> (MacRuby only)
  # * <tt>:gson</tt> (JRuby only)
  def use(new_adapter)
    @adapter = load_adapter(new_adapter)
  end
  alias :adapter= :use
  # :nodoc:
  alias :engine= :use

  def load_adapter(new_adapter)
    case new_adapter
    when String, Symbol
      require "multi_json/adapters/#{new_adapter}"
      MultiJson::Adapters.const_get(:"#{new_adapter.to_s.split('_').map{|s| s.capitalize}.join('')}")
    when NilClass, FalseClass
      load_adapter default_adapter
    when Class, Module
      new_adapter
    else
      raise "Did not recognize your adapter specification. Please specify either a symbol or a class."
    end
  end

  # Decode a JSON string into Ruby.
  #
  # <b>Options</b>
  #
  # <tt>:symbolize_keys</tt> :: If true, will use symbols instead of strings for the keys.
  # <tt>:adapter</tt> :: If set, the selected engine will be used just for the call.
  def load(string, options={})
    adapter = current_adapter(options)
    begin
      adapter.load(string, options)
    rescue adapter::ParseError => exception
      raise LoadError.new(exception.message, exception.backtrace, string)
    end
  end
  # :nodoc:
  alias :decode :load

  def current_adapter(options)
    if new_adapter = (options || {}).delete(:adapter)
      load_adapter(new_adapter)
    else
      adapter
    end
  end

  # Encodes a Ruby object as JSON.
  def dump(object, options={})
    options = default_options.merge(options)
    adapter = current_adapter(options)
    adapter.dump(object, options)
  end
  # :nodoc:
  alias :encode :dump

  #  Executes passed block using specified adapter.
  def with_adapter(new_adapter)
    old_adapter, self.adapter = adapter, new_adapter
    yield
  ensure
    self.adapter = old_adapter
  end
  # :nodoc:
  alias :with_engine :with_adapter

end
