require "spec_helper"

describe MultiJson::OptionsCache do
  before { described_class.reset }

  it "doesn't leak memory" do
    described_class::MAX_CACHE_SIZE.succ.times do |i|
      described_class.fetch(:dump, :key => i) do
        { :foo => i }
      end

      described_class.fetch(:load, :key => i) do
        { :foo => i }
      end
    end

    expect(described_class.instance_variable_get(:@dump_cache).length).to eq(1)
    expect(described_class.instance_variable_get(:@load_cache).length).to eq(1)
  end
end
