require "spec_helper"
require "shared/adapter"
require "multi_json/adapters/jr_jackson"

RSpec.describe MultiJson::Adapters::JrJackson, :jrjackson => true do
  it_behaves_like "an adapter", described_class
end
