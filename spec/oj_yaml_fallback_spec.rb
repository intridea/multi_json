require 'multi_json/adapters/oj_yaml_fallback'

describe MultiJson::Adapters::OjYamlFallback do
  let(:parser) { MultiJson::Adapters::OjYamlFallback }
  before do 
    @last_error_json = nil
    parser.error_callback = lambda do |json|
      @last_error_json = json
    end
  end

  it "should not set the error json on valid json" do
    parser.load('{"abc":"def"}').should == {'abc' => 'def'}
    @last_error_json.should == nil
  end

  it "should not set the error json on invalid json" do
    lambda do
      parser.load('{{{"abc":"def"}')
    end.should raise_error(parser::ParseError)
    @last_error_json.should == nil
  end

  it "should set the error json on invalid json that was valid in rails 2" do
    json_string = "{abc: def}"
    parser.load(json_string)
    @last_error_json.should == json_string
  end
end
