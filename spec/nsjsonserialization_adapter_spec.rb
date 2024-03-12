require 'spec_helper'

return if skip_adapter?("nsjsonserialization")

require 'shared/adapter'
require 'multi_json/adapters/nsjsonserialization'

describe MultiJson::Adapters::Nsjsonserialization do
  it_behaves_like 'an adapter', described_class
end
