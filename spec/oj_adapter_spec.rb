require 'spec_helper'

exit 0 if skip_adapter?('oj')

require 'shared/adapter'
require 'multi_json/adapters/oj'

describe MultiJson::Adapters::Oj do
  it_behaves_like 'an adapter', described_class

  describe '.dump' do
    describe '#dump_options' do
      around { |example| with_default_options(&example) }

      it 'ensures indent is a Fixnum' do
        expect { MultiJson.dump(42, :indent => '') }.not_to raise_error
      end
    end
  end

  it 'Oj does not create symbols on parse' do
    MultiJson.load('{"json_class":"ZOMG"}')

    expect do
      MultiJson.load('{"json_class":"OMG"}')
    end.to_not change { Symbol.all_symbols.count }
  end

  context 'with Oj.default_settings' do
    around do |example|
      options = Oj.default_options
      Oj.default_options = {:symbol_keys => true}
      example.call
      Oj.default_options = options
    end

    it 'ignores global settings' do
      example = '{"a": 1, "b": 2}'
      expected = {'a' => 1, 'b' => 2}
      expect(MultiJson.load(example)).to eq(expected)
    end
  end
end
