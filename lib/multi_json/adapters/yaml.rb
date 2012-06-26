require 'multi_json/adapters/json_common'

module MultiJson
  module Adapters
    # Use the Oj library to dump/load.
    class Yaml
      extend JsonCommon

      ParseError = SyntaxError
      DATE_REGEX = /^(?:\d{4}-\d{2}-\d{2}|\d{4}-\d{1,2}-\d{1,2}[ \t]+\d{1,2}:\d{2}:\d{2}(\.[0-9]*)?(([ \t]*)Z|[-+]\d{2}?(:\d{2})?))$/
      

      def self.load(string, options={}) #:nodoc:
        # Convert to string if we get a stringio object.
        string = string.read if string.respond_to?(:read)
        json = YAML.load(convert_json_to_yaml(string))
        if options[:symbolize_keys] 
          json = symbolize_keys(json)
        end
        json
      rescue ArgumentError, TypeError
        raise ParseError, "Invalid JSON string.\n#{string}\n#{$!}"
      end

      private
      def self.convert_json_to_yaml(json) #:nodoc:
        require 'strscan' unless defined? ::StringScanner
        scanner, quoting, marks, pos, times = ::StringScanner.new(json), false, [], nil, []
        while scanner.scan_until(/(\\['"]|['":,\\]|\\.)/)
          case char = scanner[1]
          when '"', "'"
            if !quoting
              quoting = char
              pos = scanner.pos
            elsif quoting == char
              if json[pos..scanner.pos-2] =~ DATE_REGEX
                # found a date, track the exact positions of the quotes so we can
                # overwrite them with spaces later.
                times << pos << scanner.pos
              end
              quoting = false
            end
          when ":",","
            marks << scanner.pos - 1 unless quoting
          when "\\"
            scanner.skip(/\\/)
          end
        end

        if marks.empty?
          json.gsub(/\\([\\\/]|u[[:xdigit:]]{4})/) do
            ustr = $1
            if ustr.start_with?('u')
              [ustr[1..-1].to_i(16)].pack("U")
            elsif ustr == '\\'
              '\\\\'
            else
              ustr
            end
          end
        else
          left_pos  = [-1].push(*marks)
          right_pos = marks << scanner.pos + scanner.rest_size
          output    = []
          left_pos.each_with_index do |left, i|
            scanner.pos = left.succ
            chunk = scanner.peek(right_pos[i] - scanner.pos + 1)
            # overwrite the quotes found around the dates with spaces
            while times.size > 0 && times[0] <= right_pos[i]
              chunk[times.shift - scanner.pos - 1] = ' '
            end
            chunk.gsub!(/\\([\\\/]|u[[:xdigit:]]{4})/) do
              ustr = $1
              if ustr.start_with?('u')
                [ustr[1..-1].to_i(16)].pack("U")
              elsif ustr == '\\'
                '\\\\'
              else
                ustr
              end
            end
            output << chunk
          end
          output = output * " "

          output.gsub!(/\\\//, '/')
          output
        end
      end

      def self.symbolize_keys(object)
        if object.is_a?(Hash)
          object.inject({}) do |result, (key, value)|
            new_key = case key
                        when String then key.to_sym
                        else key
                      end

            new_value = symbolize_keys(value)
            result[new_key] = new_value
            result
          end
        elsif object.is_a?(Array)
          object.map do |o|
            symbolize_keys o
          end
        else
          object
        end
      end
    end
  end
end

