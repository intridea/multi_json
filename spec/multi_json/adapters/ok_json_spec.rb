require "spec_helper"
require "shared/adapter"
require "multi_json/adapters/ok_json"

RSpec.describe MultiJson::Adapters::OkJson, :ok_json => true do
  it_behaves_like "an adapter", described_class
end
