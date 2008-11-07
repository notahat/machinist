require File.dirname(__FILE__) + '/spec_helper'
require 'sham'

Sham.random { rand }
Sham.half_index {|index| index/2 }
Sham.coin_toss(:unique => false) {|index| index % 2 == 1 ? 'heads' : 'tails' }
Sham.limited {|index| index%10 }
Sham.index {|index| index }
Sham.name  {|index| index }

describe Sham do
  it "should ensure generated values are unique" do
    values = (1..10).map { Sham.half_index }
    values.should == (0..9).to_a
  end

  it "should generate non-unique values when asked" do
    values = (1..4).map { Sham.coin_toss }
    values.should == ['heads', 'tails', 'heads', 'tails']
  end
  
  it "should generate more than a dozen values" do
    values = (1..25).map { Sham.index }
    values.should == (1..25).to_a
  end
    
  it "should generate the same sequence of values after a reset" do
    values1 = (1..10).map { Sham.random }
    Sham.reset
    values2 = (1..10).map { Sham.random }
    values2.should == values1
  end
  
  it "should die when it runs out of unique values" do
    lambda {
      (1..100).map { Sham.limited }
    }.should raise_error(RuntimeError)
  end
  
  it "should allow over-riding the name method" do
    Sham.name.should == 1
  end
  
    
end
