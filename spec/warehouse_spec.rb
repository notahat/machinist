require File.dirname(__FILE__) + '/spec_helper'

describe Machinist::Warehouse do
  
  it "should store and retrieve values" do
    warehouse = Machinist::Warehouse.new
    warehouse[1, 2] = "example"
    warehouse[1, 2].should == "example"
  end
  
  it "should return an empty array for a new key" do
    warehouse = Machinist::Warehouse.new
    warehouse[1, 2].should == []
    warehouse[3, 4] << "example"
    warehouse[3, 4].should == ["example"]
  end
  
  it "should clone" do
    warehouse = Machinist::Warehouse.new
    warehouse[1, 2] = "example"
    warehouse.clone.should == warehouse
  end
  
end
