$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'sham'

Sham.numbers_up_to_12  { rand 12 }
Sham.numbers_up_to_100 { rand 100 }

describe Sham do
  before do
    Sham.reset
  end
  
  it "should ensure generated values are unique" do
    values = (1..12).map { Sham.numbers_up_to_12 }
    values.should == values.uniq
  end
  
  it "should generate more than a dozen values" do
    values = (1..25).map { Sham.numbers_up_to_100 }
    values.each do |value|
      value.class.should == Fixnum
    end
  end
    
  it "should generate the same sequence of values after a reset" do
    values1 = (1..12).map { Sham.numbers_up_to_12 }
    Sham.reset
    values2 = (1..12).map { Sham.numbers_up_to_12 }
    values2.should == values1
  end
  
end
