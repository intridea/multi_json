require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class MockDecoder
  def self.decode(string, options = {})
    {'abc' => 'def'}
  end
  
  def self.encode(string)
    '{"abc":"def"}'
  end
end

describe "MultiJson" do
  context 'engines' do
    it 'should default to the best available gem' do
      require 'yajl'
      MultiJson.engine.name.should == 'MultiJson::Engines::Yajl'
    end

    it 'should be settable via a symbol' do
      MultiJson.engine = :yajl
      MultiJson.engine.name.should == 'MultiJson::Engines::Yajl'
    end
    
    it 'should be settable via a class' do
      MultiJson.engine = MockDecoder
      MultiJson.engine.name.should == 'MockDecoder'
    end
  end
  
  %w(active_support json_gem json_pure yajl).each do |engine|
    context engine do
      before do
        begin
          MultiJson.engine = engine
        rescue LoadError
          pending "Engine #{engine} couldn't be loaded (not installed?)"
        end
      end
      
      describe '.encode' do
        it 'should write decodable JSON' do
          [
            {'abc' => 'def'},
            [1, 2, 3, "4"]
          ].each do |example|
            MultiJson.decode(MultiJson.encode(example)).should == example
          end
        end
      end
      
      describe '.decode' do
        it 'should properly decode some json' do
          MultiJson.decode('{"abc":"def"}').should == {'abc' => 'def'}
        end
        
        it 'should allow for symbolization of keys' do
          MultiJson.decode('{"abc":{"def":"hgi"}}', :symbolize_keys => true).should == {:abc => {:def => 'hgi'}}
        end
        
        describe 'with invalid json'
          it 'should raise a MultiJson::ParseError' do
            lambda { MultiJson.decode('bad data') }.should raise_error(MultiJson::ParseError)
          end
          
          it 'raised exception should preserve backtrace' do
            lambda {MultiJson.decode('bad data')}.should raise_error do |e|
              e.backtrace.any? {|e| e =~ /multi_json\/engines/}.should be_true
            end
          end
      end
    end
  end
end
