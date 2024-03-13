libx = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(libx) unless $LOAD_PATH.include?(libx)

require 'oj'
require 'fast_jsonparser'
require 'multi_json'
require 'benchmark/ips'

MultiJson.use :oj

Benchmark.ips do |x|
  x.time = 10
  x.warmup = 1
  x.report("oj") { MultiJson.load(MultiJson.dump(a: 1, b: 2, c: 3)) }
end

MultiJson.use :fast_jsonparser

Benchmark.ips do |x|
  x.time = 10
  x.warmup = 1
  x.report("fast_jsonparser") { MultiJson.load(MultiJson.dump(a: 1, b: 2, c: 3)) }
end
