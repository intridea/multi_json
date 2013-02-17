require 'singleton'
require 'forwardable'
require 'multi_json/options'

module MultiJson
  class Adapter
    extend Options
    include Singleton
    class << self
      extend Forwardable
      def_delegators :instance, :load, :dump
    end
  end
end