require File.dirname(__FILE__) + '/spec_helper'
require 'ostruct'

describe Machinist::Blueprint do

  it "should make an object of the given class" do
    blueprint = Machinist::Blueprint.new(OpenStruct) { }
    blueprint.make.should be_an(OpenStruct)
  end

  it "should construct an attribute in the blueprint" do
    blueprint = Machinist::Blueprint.new(OpenStruct) do
      name { "Fred" }
    end
    blueprint.make.name.should == "Fred"
  end

  it "should construct an array for an attribute in the blueprint" do
    blueprint = Machinist::Blueprint.new(OpenStruct) do
      things(3) { Object.new }
    end
    things = blueprint.make.things
    things.should be_an(Array)
    things.should have(3).elements
    things.each {|thing| thing.should be_an(Object) }
    things.uniq.should == things
  end

  it "should allow passing in attributes to override the blueprint" do
    block_called = false
    blueprint = Machinist::Blueprint.new(OpenStruct) do
      name { block_called = true; "Fred" }
    end
    blueprint.make(:name => "Bill").name.should == "Bill"
    block_called.should be_false
  end

  it "should provide a serial number within the blueprint" do
    blueprint = Machinist::Blueprint.new(OpenStruct) do
      name { "Fred #{sn}" }
    end
    blueprint.make.name.should == "Fred 0001"
    blueprint.make.name.should == "Fred 0002"
  end

  it "should provide access to the object being constructed within the blueprint" do
    blueprint = Machinist::Blueprint.new(OpenStruct) do
      title { "Test" }
      body  { object.title }
    end
    blueprint.make.body.should == "Test"
  end

  it "should allow attribute names to be strings" do
    blueprint = Machinist::Blueprint.new(OpenStruct) do
      name { "Fred" }
    end
    blueprint.make("name" => "Bill").name.should == "Bill"
  end

  it "should work with type and id attributes" do
    klass = Class.new do
      attr_accessor :id, :type
    end
    blueprint = Machinist::Blueprint.new(klass) do
      id   { "custom id" }
      type { "custom type" }
    end
    object = blueprint.make
    object.id.should == "custom id"
    object.type.should == "custom type"
  end

end
