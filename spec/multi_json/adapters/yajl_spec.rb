require "spec_helper"
return unless RSpec.configuration.yajl?

require "shared/adapter"
require "multi_json/adapters/yajl"

RSpec.describe MultiJson::Adapters::Yajl, yajl: true do
  it_behaves_like "an adapter", described_class
end
