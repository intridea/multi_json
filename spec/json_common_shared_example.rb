shared_examples_for 'JSON-like adapter' do |adapter|
  before do
    begin
      MultiJson.use adapter
    rescue LoadError
      pending "Adapter #{adapter} couldn't be loaded (not installed?)"
    end
  end

  describe '.dump' do
    describe 'with :pretty option set to true' do
      it 'passes default pretty options' do
        ::JSON.should_receive(:generate).with(['foo'], JSON::PRETTY_STATE_PROTOTYPE.to_h).and_return('["foo"]')
        MultiJson.dump('foo', :pretty => true)
      end
    end

    describe 'with :indent option' do
      it 'passes it on dump' do
        ::JSON.should_receive(:generate).with(['foo'], {:indent => "\t"}).and_return('["foo"]')
        MultiJson.dump('foo', :indent => "\t")
      end
    end
  end

  describe '.load' do
    describe 'with :quirks_mode option' do
      it 'passes it on load' do
        ::JSON.should_receive(:parse).with('["foo"]', {:quirks_mode => true, :create_additions => false}).and_return(['foo'])
        MultiJson.load('"foo"', :quirks_mode => true)
      end
    end
  end
end