require 'yajl' unless defined?(Yajl)

module XToJson
  module Engines
    class Yajl
      def self.decode(string, options = {})
        ::Yajl::Parser.new(:symbolize_keys => options[:symbolize_keys]).parse(string)
      end
      
      def self.encode(object)
        ::Yajl::Encoder.new.encode(object)
      end
    end
  end
end