require "shared/options"
require "stringio"

shared_examples_for "an adapter" do |adapter|
  before { MultiJson.use adapter }

  it_behaves_like "has options", adapter

  it "does not modify argument hashes" do
    options = {symbolize_keys: true, pretty: false, adapter: :ok_json}
    expect { MultiJson.load("{}", options) }.not_to(change { options })
    expect { MultiJson.dump([42], options) }.not_to(change { options })
  end

  describe ".dump" do
    describe "#dump_options" do
      before { MultiJson.dump_options = MultiJson.adapter.dump_options = {} }

      after do
        MultiJson.dump(1, fizz: "buzz")
        MultiJson.dump_options = MultiJson.adapter.dump_options = nil
      end

      it "respects global dump options" do
        MultiJson.dump_options = {foo: "bar"}
        expect(MultiJson.dump_options).to eq({foo: "bar"})
        expect(MultiJson.adapter.instance).to receive(:dump).with(1, {foo: "bar", fizz: "buzz"})
      end

      it "respects per-adapter dump options" do
        MultiJson.adapter.dump_options = {foo: "bar"}
        expect(MultiJson.adapter.dump_options).to eq({foo: "bar"})
        expect(MultiJson.adapter.instance).to receive(:dump).with(1, {foo: "bar", fizz: "buzz"})
      end

      it "adapter-specific are overridden by global options" do
        MultiJson.adapter.dump_options = {foo: "foo"}
        MultiJson.dump_options = {foo: "bar"}
        expect(MultiJson.adapter.dump_options).to eq({foo: "foo"})
        expect(MultiJson.dump_options).to eq({foo: "bar"})
        expect(MultiJson.adapter.instance).to receive(:dump).with(1, {foo: "bar", fizz: "buzz"})
      end
    end

    it "writes decodable JSON" do
      examples = [
        {"abc" => "def"},
        [],
        1,
        "2",
        true,
        false,
        nil
      ]

      examples.each do |example|
        expect(MultiJson.load(MultiJson.dump(example))).to eq(example)
      end
    end

    let(:json_pure){ Kernel.const_get('MultiJson::Adapters::JsonPure') rescue nil }

    it "dumps time in correct format" do
      time = Time.at(1_355_218_745).utc

      dumped_json = MultiJson.dump(time)
      expected = "2012-12-11 09:39:05 UTC"
      expect(MultiJson.load(dumped_json)).to eq(expected)
    end

    it "dumps symbol and fixnum keys as strings" do
      [
        [
          {foo: {bar: "baz"}},
          {"foo" => {"bar" => "baz"}}
        ],
        [
          [{foo: {bar: "baz"}}],
          [{"foo" => {"bar" => "baz"}}]
        ],
        [
          {foo: [{bar: "baz"}]},
          {"foo" => [{"bar" => "baz"}]}
        ],
        [
          {1 => {2 => {3 => "bar"}}},
          {"1" => {"2" => {"3" => "bar"}}}
        ]
      ].each do |example, expected|
        dumped_json = MultiJson.dump(example)
        expect(MultiJson.load(dumped_json)).to eq(expected)
      end
    end

    it "dumps rootless JSON" do
      expect(MultiJson.dump("random rootless string")).to eq('"random rootless string"')
      expect(MultiJson.dump(123)).to eq("123")
    end

    it "passes options to the adapter" do
      expect(MultiJson.adapter).to receive(:dump).with("foo", {bar: :baz})
      MultiJson.dump("foo", {bar: :baz})
    end

    it "dumps custom objects that implement to_json" do
      pending "not supported" if adapter.name == "MultiJson::Adapters::Gson"
      klass = Class.new do
        def to_json(*)
          '"foobar"'
        end
      end
      expect(MultiJson.dump(klass.new)).to eq('"foobar"')
    end

    it "allows to dump JSON values" do
      expect(MultiJson.dump(42)).to eq("42")
    end

    it "allows to dump JSON with UTF-8 characters" do
      expect(MultiJson.dump("color" => "żółć")).to eq('{"color":"żółć"}')
    end
  end

  describe ".load" do
    describe "#load_options" do
      before { MultiJson.load_options = MultiJson.adapter.load_options = {} }

      after do
        MultiJson.load("1", fizz: "buzz")
        MultiJson.load_options = MultiJson.adapter.load_options = nil
      end

      it "respects global load options" do
        MultiJson.load_options = {foo: "bar"}
        expect(MultiJson.load_options).to eq({foo: "bar"})
        expect(MultiJson.adapter.instance).to receive(:load).with("1", {foo: "bar", fizz: "buzz"})
      end

      it "respects per-adapter load options" do
        MultiJson.adapter.load_options = {foo: "bar"}
        expect(MultiJson.adapter.load_options).to eq({foo: "bar"})
        expect(MultiJson.adapter.instance).to receive(:load).with("1", {foo: "bar", fizz: "buzz"})
      end

      it "adapter-specific are overridden by global options" do
        MultiJson.adapter.load_options = {foo: "foo"}
        MultiJson.load_options = {foo: "bar"}
        expect(MultiJson.adapter.load_options).to eq({foo: "foo"})
        expect(MultiJson.load_options).to eq({foo: "bar"})
        expect(MultiJson.adapter.instance).to receive(:load).with("1", {foo: "bar", fizz: "buzz"})
      end
    end

    it "does not modify input" do
      input = %(\n\n  {"foo":"bar"} \n\n\t)
      expect do
        MultiJson.load(input)
      end.not_to(change { input })
    end

    it "does not modify input encoding" do
      input = "[123]"
      input.force_encoding("iso-8859-1")

      expect do
        MultiJson.load(input)
      end.not_to(change { input.encoding })
    end

    it "properly loads valid JSON" do
      expect(MultiJson.load('{"abc":"def"}')).to eq("abc" => "def")
    end

    examples = [nil, '{"abc"}', " ", "\t\t\t", "\n", StringIO.new("")]
    #
    # GSON bug: https://github.com/avsej/gson.rb/issues/3
    examples << "\x82\xAC\xEF" unless adapter.name.include?("Gson")

    examples.each do |input|
      it "raises MultiJson::ParseError on invalid input: #{input.inspect}" do
        expect { MultiJson.load(input) }.to raise_error(MultiJson::ParseError)
      end
    end

    it "raises MultiJson::ParseError with data on invalid JSON" do
      data = "{invalid}"
      exception = get_exception(MultiJson::ParseError) { MultiJson.load data }
      expect(exception.data).to eq(data)
      expect(exception.cause).to match(adapter::ParseError)
    end

    it "catches MultiJson::DecodeError for legacy support" do
      data = "{invalid}"
      exception = get_exception(MultiJson::DecodeError) { MultiJson.load data }
      expect(exception.data).to eq(data)
      expect(exception.cause).to match(adapter::ParseError)
    end

    it "catches MultiJson::LoadError for legacy support" do
      data = "{invalid}"
      exception = get_exception(MultiJson::LoadError) { MultiJson.load data }
      expect(exception.data).to eq(data)
      expect(exception.cause).to match(adapter::ParseError)
    end

    it "stringifys symbol keys when encoding" do
      dumped_json = MultiJson.dump(a: 1, b: {c: 2})
      loaded_json = MultiJson.load(dumped_json)
      expect(loaded_json).to eq("a" => 1, "b" => {"c" => 2})
    end

    it "properly loads valid JSON in StringIOs" do
      json = StringIO.new('{"abc":"def"}')
      expect(MultiJson.load(json)).to eq("abc" => "def")
    end

    it "allows for symbolization of keys" do
      [
        [
          '{"abc":{"def":"hgi"}}',
          {abc: {def: "hgi"}}
        ],
        [
          '[{"abc":{"def":"hgi"}}]',
          [{abc: {def: "hgi"}}]
        ],
        [
          '{"abc":[{"def":"hgi"}]}',
          {abc: [{def: "hgi"}]}
        ]
      ].each do |example, expected|
        expect(MultiJson.load(example, symbolize_keys: true)).to eq(expected)
      end
    end

    it "allows to load JSON values" do
      expect(MultiJson.load("42")).to eq(42)
    end

    it "allows to load JSON with UTF-8 characters" do
      expect(MultiJson.load('{"color":"żółć"}')).to eq("color" => "żółć")
    end
  end
end
