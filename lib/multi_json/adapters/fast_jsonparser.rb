require 'fast_jsonparser'
require 'oj'
require 'multi_json/adapter'

module MultiJson
  module Adapters
    # Use the Oj library to dump/load.
    class FastJsonparser < Adapter
      defaults :load, :symbolize_keys => false
      defaults :dump, :mode => :compat, :time_format => :ruby, :use_to_json => true

      ParseError = ::FastJsonparser::Error

      def load(string, options = {})
        ::FastJsonparser.parse(string, options)
      end

      case ::Oj::VERSION
      when /\A2\./
        def dump(object, options = {})
          options.merge!(:indent => 2) if options[:pretty]
          options[:indent] = options[:indent].to_i if options[:indent]
          ::Oj.dump(object, options)
        end
      when /\A3\./
        PRETTY_STATE_PROTOTYPE = {
          :indent                => "  ",
          :space                 => " ",
          :space_before          => "",
          :object_nl             => "\n",
          :array_nl              => "\n",
          :ascii_only            => false,
        }

        def dump(object, options = {})
          options.merge!(PRETTY_STATE_PROTOTYPE.dup) if options.delete(:pretty)
          ::Oj.dump(object, options)
        end
      else
        fail "Unsupported Oj version: #{::Oj::VERSION}"
      end
    end
  end
end
