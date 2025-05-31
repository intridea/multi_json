require "spec_helper"
return unless RSpec.configuration.gson?

require "shared/adapter"
require "multi_json/adapters/gson"

RSpec.describe MultiJson::Adapters::Gson, :gson do
  it_behaves_like "an adapter", described_class
end
