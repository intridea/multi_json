require 'spec_helper'

exit 0 if skip_adapter?('jr_jackson')

require 'shared/adapter'
require 'multi_json/adapters/jr_jackson'

describe MultiJson::Adapters::JrJackson do
  it_behaves_like 'an adapter', described_class
end
