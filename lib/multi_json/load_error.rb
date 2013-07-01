module MultiJson
  class LoadError < StandardError
    attr_reader :data
    def initialize(message='', backtrace=[], data='')
      super(message)
      self.set_backtrace(backtrace)
      @data = data
    end
  end
  DecodeError = LoadError # Legacy support
end