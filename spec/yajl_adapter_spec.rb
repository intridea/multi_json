require 'spec_helper'

exit 0 if skip_adapter?('yajl')

require 'shared/adapter'
require 'multi_json/adapters/yajl'

describe MultiJson::Adapters::Yajl do
  it_behaves_like 'an adapter', described_class
end
