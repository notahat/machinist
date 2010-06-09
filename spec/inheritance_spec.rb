require File.dirname(__FILE__) + '/spec_helper'
require 'machinist/blueprint'
require 'machinist/lathe'

describe Machinist::Blueprint, "inheritance" do

  it "should inherit attributes from the parent blueprint" do
    parent_blueprint = Machinist::Blueprint.new do
      name { "Fred" }
      age  { 97 }
    end

    child_blueprint = Machinist::Blueprint.new(:parent => parent_blueprint) do
      name { "Bill" } 
    end

    child = child_blueprint.make
    child.name.should == "Bill"
    child.age.should == 97
  end

  it "should take the serial number from the parent" do
    parent_blueprint = Machinist::Blueprint.new do
      parent_serial { sn }
    end

    child_blueprint = Machinist::Blueprint.new(:parent => parent_blueprint) do
      child_serial { sn }
    end

    parent_blueprint.make.parent_serial.should == "0001"
    child_blueprint.make.child_serial.should == "0002"
    parent_blueprint.make.parent_serial.should == "0003"
  end

end
