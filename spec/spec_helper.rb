require "multi_json"
require "rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def silence_warnings
  old_verbose = $VERBOSE
  $VERBOSE = nil
  yield
ensure
  $VERBOSE = old_verbose
end

def macruby?
  defined?(RUBY_ENGINE) && RUBY_ENGINE == "macruby"
end

def jruby?
  defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"
end

def skip_adapter?(adapter_name)
  @skip ||=
    ENV.fetch("SKIP_ADAPTERS", "")
      .split(",")
      .then do |skip|
      if jruby?
        %w[oj yajl] + skip
      else
        %w[gson] + skip
      end
    end
  @skip.include?(adapter_name)
end

def undefine_constants(*consts)
  values = {}
  consts.each do |const|
    if Object.const_defined?(const)
      values[const] = Object.const_get(const)
      Object.send :remove_const, const
    end
  end

  yield
ensure
  values.each do |const, value|
    Object.const_set const, value
  end
end

def break_requirements
  requirements = MultiJson::REQUIREMENT_MAP
  MultiJson::REQUIREMENT_MAP.each_with_index do |(adapter, library), index|
    MultiJson::REQUIREMENT_MAP[index] = [adapter, "foo/#{library}"]
  end

  yield
ensure
  requirements.each_with_index do |(adapter, library), index|
    MultiJson::REQUIREMENT_MAP[index] = [adapter, library]
  end
end

def simulate_no_adapters(&block)
  break_requirements do
    undefine_constants :JSON, :Oj, :Yajl, :Gson, :JrJackson, &block
  end
end

def get_exception(exception_class = StandardError)
  yield
rescue exception_class => e
  e
end

def with_default_options
  adapter = MultiJson.adapter
  adapter.load_options = adapter.dump_options = MultiJson.load_options = MultiJson.dump_options = nil
  yield
ensure
  adapter.load_options = adapter.dump_options = MultiJson.load_options = MultiJson.dump_options = nil
end
