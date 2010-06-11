require File.dirname(__FILE__) + '/spec_helper'

module BlueprintSpecs
  class Post
    extend Machinist::Machinable
    attr_accessor :title, :body
  end
end

describe Machinist::Blueprint do

  it "should make an OpenStruct by default" do
    blueprint = Machinist::Blueprint.new { }
    blueprint.make.should be_an(OpenStruct)
  end

  it "should make a provided class" do
    blueprint = Machinist::Blueprint.new(:class => BlueprintSpecs::Post) { }
    blueprint.make.should be_a(BlueprintSpecs::Post)
  end

  it "should set attributes from the blueprint" do
    blueprint = Machinist::Blueprint.new do
      name { "Fred" }
    end
    blueprint.make.name.should == "Fred"
  end

  it "should provide an index within the blueprint" do
    blueprint = Machinist::Blueprint.new do
      name { "Fred #{sn}" }
    end
    blueprint.make.name.should == "Fred 0001"
    blueprint.make.name.should == "Fred 0002"
  end

  it "should allow passing in attributes to override the blueprint" do
    block_called = false
    blueprint = Machinist::Blueprint.new do
      name { block_called = true; "Fred" }
    end
    blueprint.make(:name => "Bill").name.should == "Bill"
    block_called.should be_false
  end

  it "should allow reading previously assigned attributes within the blueprint" do
    blueprint = Machinist::Blueprint.new do
      title { "Test" }
      body  { title }
    end
    blueprint.make.body.should == "Test"
  end

  it "should provide access to the object being constructed in the blueprint" do
    post = nil
    blueprint = Machinist::Blueprint.new(:class => BlueprintSpecs::Post) { post = object }
    blueprint.make
    post.should be_a(BlueprintSpecs::Post)
  end

  it "should allow overridden attribute names to be strings" do
    blueprint = Machinist::Blueprint.new do
      name { "Fred" }
    end
    blueprint.make("name" => "Bill").name.should == "Bill"
  end

  it "should raise if you try to read an unassigned attribute" do
    blueprint = Machinist::Blueprint.new do
      body { title }
    end
    lambda {
      blueprint.make
    }.should raise_error("Can't find a class for the attribute: title")
  end
  
end
