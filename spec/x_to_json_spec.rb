require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class MockDecoder
  def self.decode(string, options = {})
    {'abc' => 'def'}
  end
  
  def self.encode(string)
    '{"abc":"def"}'
  end
end

describe "XToJson" do
  context 'engines' do
    it 'should default to the best available gem' do
      require 'yajl'
      XToJson.engine.name.should == 'XToJson::Engines::Yajl'
    end

    it 'should be settable via a symbol' do
      XToJson.engine = :yajl
      XToJson.engine.name.should == 'XToJson::Engines::Yajl'
    end
    
    it 'should be settable via a class' do
      XToJson.engine = MockDecoder
      XToJson.engine.name.should == 'MockDecoder'
    end
  end
  
  %w(active_support json_gem json_pure yajl).each do |engine|
    context engine do
      before do
        XToJson.engine = engine
      end
      
      describe '.encode' do
        it 'should write decodable JSON' do
          [
            {'abc' => 'def'},
            [1, 2, 3, "4"]
          ].each do |example|
            XToJson.decode(XToJson.encode(example)).should == example
          end
        end
      end
      
      describe '.decode' do
        it 'should properly decode some json' do
          XToJson.decode('{"abc":"def"}').should == {'abc' => 'def'}
        end
        
        it 'should allow for symbolization of keys' do
          XToJson.decode('{"abc":{"def":"hgi"}}', :symbolize_keys => true).should == {:abc => {:def => 'hgi'}}
        end
      end
    end
  end
end
