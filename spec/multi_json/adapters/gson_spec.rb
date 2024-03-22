require "spec_helper"
require "shared/adapter"
require "multi_json/adapters/gson"

RSpec.describe MultiJson::Adapters::Gson, :gson => true do
  it_behaves_like "an adapter", described_class
end
