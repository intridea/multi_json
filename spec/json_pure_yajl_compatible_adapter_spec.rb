require 'spec_helper'
require 'shared/adapter'
require 'shared/json_common_adapter'
require 'multi_json/adapters/json_pure'

require 'yajl/json_gem'

describe MultiJson::Adapters::JsonPure, "Yajl compatible" do
  it_behaves_like 'an adapter', described_class
  it_behaves_like 'JSON-like adapter', described_class
end