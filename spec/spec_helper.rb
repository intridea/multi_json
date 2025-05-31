require "multi_json"
require "rspec"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # You must run 'bundle exec rake' for this to work properly
  loaded_specs = Gem.loaded_specs

  config.add_setting :java, default: RUBY_PLATFORM == 'java'
  config.add_setting :gson, default: loaded_specs.has_key?('gson')
  config.add_setting :json, default: loaded_specs.has_key?('json')
  config.add_setting :json_pure, default: loaded_specs.has_key?('json_pure')
  config.add_setting :jrjackson, default: loaded_specs.has_key?('jrjackson')
  config.add_setting :ok_json, default: loaded_specs.has_key?('ok_json')
  config.add_setting :oj, default: loaded_specs.has_key?('oj')
  config.add_setting :yajl, default: loaded_specs.has_key?('yajl')

  config.filter_run_excluding(:jrjackson) unless config.jrjackson?
  config.filter_run_excluding(:json) unless config.json?
  config.filter_run_excluding(:json_pure) unless config.json_pure?
  config.filter_run_excluding(:ok_json) unless config.ok_json?
  config.filter_run_excluding(:oj) unless config.oj?
  config.filter_run_excluding(:yajl) unless config.yajl?

  unless config.java?
    config.filter_run_excluding(:java)
    config.filter_run_excluding(:gson) unless config.gson?
  end
end

def silence_warnings
  old_verbose = $VERBOSE
  $VERBOSE = nil
  yield
ensure
  $VERBOSE = old_verbose
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
  MultiJson::REQUIREMENT_MAP.each do |adapter, library|
    MultiJson::REQUIREMENT_MAP[adapter] = "foo/#{library}"
  end

  yield
ensure
  requirements.each do |adapter, library|
    MultiJson::REQUIREMENT_MAP[adapter] = library
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
