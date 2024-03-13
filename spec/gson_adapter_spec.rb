require 'spec_helper'

return if skip_adapter?('gson')

require 'shared/adapter'
require 'multi_json/adapters/gson'

describe MultiJson::Adapters::Gson do
  it_behaves_like 'an adapter', described_class
end
