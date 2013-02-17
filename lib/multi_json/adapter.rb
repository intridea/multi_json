require 'singleton'
require 'forwardable'

module MultiJson
  class Adapter
    include Singleton
    class << self
      extend Forwardable
      def_delegators :instance, :load, :dump
    end
  end
end