require 'oj'
require 'multi_json'
require 'benchmark/ips'

MultiJson.use :oj

Benchmark.ips do |x|
  x.time = 10
  x.warmup = 1
  x.report { MultiJson.load(MultiJson.dump(a: 1, b: 2, c: 3)) }
end
