require 'spec_helper'

exit 0 if skip_adapter?('fast_jsonparser')

require 'shared/adapter'
require 'multi_json/adapters/fast_jsonparser'

describe MultiJson::Adapters::FastJsonparser do
  it_behaves_like 'an adapter', described_class
end
