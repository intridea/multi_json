require "spec_helper"
require "shared/options"

RSpec.describe MultiJson do
  let(:config) { RSpec.configuration }

  before(:all) do
    # make sure all available libs are required
    MultiJson::REQUIREMENT_MAP.each_value do |library|
      require library
    rescue LoadError
      next
    end
  end

  context "when no other json implementations are available" do
    around do |example|
      simulate_no_adapters { example.call }
    end

    it "defaults to ok_json if no other json implementions are available" do
      silence_warnings do
        expect(described_class.default_adapter).to eq(:ok_json)
      end
    end

    it "prints a warning" do
      expect(Kernel).to receive(:warn).with(/warning/i)
      described_class.default_adapter
    end
  end

  context "when JSON pure is already loaded" do
    it "default_adapter tries to require each adapter in turn and does not assume :json_gem is already loaded" do
      require "json/pure"
      expect(JSON::JSON_LOADED).to be_truthy

      undefine_constants :Oj, :Yajl, :Gson, :JrJackson do
        # simulate that the json_gem is not loaded
        ext = defined?(JSON::Ext::Parser) ? JSON::Ext.send(:remove_const, :Parser) : nil
        begin
          expect(described_class).to receive(:require)
          described_class.default_adapter
        ensure
          stub_const("JSON::Ext::Parser", ext) if ext
        end
      end
    end
  end

  context "when caching" do
    before { described_class.use adapter }

    let(:adapter) { MultiJson::Adapters::JsonGem }
    let(:json_string) { '{"abc":"def"}' }

    it "busts caches on global options change" do
      described_class.load_options = {symbolize_keys: true}
      expect(described_class.load(json_string)).to eq(abc: "def")
      described_class.load_options = nil
      expect(described_class.load(json_string)).to eq("abc" => "def")
    end

    it "busts caches on per-adapter options change" do
      adapter.load_options = {symbolize_keys: true}
      expect(described_class.load(json_string)).to eq(abc: "def")
      adapter.load_options = nil
      expect(described_class.load(json_string)).to eq("abc" => "def")
    end
  end

  context "automatic adapter loading" do
    before do
      if described_class.instance_variable_defined?(:@adapter)
        described_class.send(:remove_instance_variable, :@adapter)
      end
    end

    it "defaults to the best available gem" do
      if config.java? && config.jrjackson?
        expect(described_class.adapter.to_s).to eq("MultiJson::Adapters::JrJackson")
      elsif config.java? && config.json?
        expect(described_class.adapter.to_s).to eq("MultiJson::Adapters::JsonGem")
      else
        expect(described_class.adapter.to_s).to eq("MultiJson::Adapters::Oj")
      end
    end

    it "looks for adapter even if @adapter variable is nil" do
      allow(described_class).to receive(:default_adapter).and_return(:ok_json)
      expect(described_class.adapter).to eq(MultiJson::Adapters::OkJson)
    end
  end

  it "is settable via a symbol" do
    described_class.use :json_gem
    expect(described_class.adapter).to eq(MultiJson::Adapters::JsonGem)
  end

  it "is settable via a case-insensitive string" do
    described_class.use "Json_Gem"
    expect(described_class.adapter).to eq(MultiJson::Adapters::JsonGem)
  end

  it "is settable via a class" do
    adapter = Class.new
    described_class.use adapter
    expect(described_class.adapter).to eq(adapter)
  end

  it "is settable via a module" do
    adapter = Module.new
    described_class.use adapter
    expect(described_class.adapter).to eq(adapter)
  end

  it "throws AdapterError on bad input" do
    expect { described_class.use "bad adapter" }.to raise_error(MultiJson::AdapterError, /bad adapter/)
  end

  it "gives access to original error when raising AdapterError" do
    exception = get_exception(MultiJson::AdapterError) { described_class.use "foobar" }
    expect(exception.cause).to be_instance_of(LoadError)
    expect(exception.message).to include("-- multi_json/adapters/foobar")
    expect(exception.message).to include("Did not recognize your adapter specification")
  end

  context "with one-shot parser" do
    it "uses the defined parser just for the call" do
      expect(MultiJson::Adapters::JsonPure).to receive(:dump).once.and_return("dump_something")
      expect(MultiJson::Adapters::JsonPure).to receive(:load).once.and_return("load_something")
      described_class.use :json_gem
      expect(described_class.dump("", adapter: :json_pure)).to eq("dump_something")
      expect(described_class.load("", adapter: :json_pure)).to eq("load_something")
      expect(described_class.adapter).to eq(MultiJson::Adapters::JsonGem)
    end
  end

  it "can set adapter for a block" do
    described_class.use :ok_json
    described_class.with_adapter(:json_pure) do
      described_class.with_engine(:json_gem) do
        expect(described_class.adapter).to eq(MultiJson::Adapters::JsonGem)
      end
      expect(described_class.adapter).to eq(MultiJson::Adapters::JsonPure)
    end
    expect(described_class.adapter).to eq(MultiJson::Adapters::OkJson)
  end

  it "JSON gem does not create symbols on parse" do
    skip "java based implementations" if config.java?

    described_class.with_engine(:json_gem) do
      described_class.load('{"json_class":"ZOMG"}')

      expect do
        described_class.load('{"json_class":"OMG"}')
      end.not_to(change { Symbol.all_symbols.count })
    end
  end

  describe "default options" do
    after(:all) { described_class.load_options = described_class.dump_options = nil }

    it "is deprecated" do
      expect(Kernel).to receive(:warn).with(/deprecated/i)
      silence_warnings { described_class.default_options = {foo: "bar"} }
    end

    it "sets both load and dump options" do
      expect(described_class).to receive(:dump_options=).with({foo: "bar"})
      expect(described_class).to receive(:load_options=).with({foo: "bar"})
      silence_warnings { described_class.default_options = {foo: "bar"} }
    end
  end

  it_behaves_like "has options", described_class

  describe "aliases", jrjackson: true do
    describe "jrjackson" do
      it "allows jrjackson alias as symbol" do
        expect { described_class.use :jrjackson }.not_to raise_error
        expect(described_class.adapter).to eq(MultiJson::Adapters::JrJackson)
      end

      it "allows jrjackson alias as string" do
        expect { described_class.use "jrjackson" }.not_to raise_error
        expect(described_class.adapter).to eq(MultiJson::Adapters::JrJackson)
      end
    end
  end
end
