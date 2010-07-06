require File.dirname(__FILE__) + '/spec_helper'
require 'ostruct'

module InheritanceSpecs
  class Grandpa
    extend Machinist::Machinable
    attr_accessor :name, :age
  end
  
  class Dad < Grandpa
    extend Machinist::Machinable
    attr_accessor :name, :age
  end

  class Son < Dad
    extend Machinist::Machinable
    attr_accessor :name, :age
  end
end

describe Machinist::Blueprint do

  describe "explicit inheritance" do
    it "should inherit attributes from the parent blueprint" do
      parent_blueprint = Machinist::Blueprint.new(OpenStruct) do
        name { "Fred" }
        age  { 97 }
      end

      child_blueprint = Machinist::Blueprint.new(OpenStruct, :parent => parent_blueprint) do
        name { "Bill" } 
      end

      child = child_blueprint.make
      child.name.should == "Bill"
      child.age.should == 97
    end

    it "should take the serial number from the parent" do
      parent_blueprint = Machinist::Blueprint.new(OpenStruct) do
        parent_serial { sn }
      end

      child_blueprint = Machinist::Blueprint.new(OpenStruct, :parent => parent_blueprint) do
        child_serial { sn }
      end

      parent_blueprint.make.parent_serial.should == "0001"
      child_blueprint.make.child_serial.should == "0002"
      parent_blueprint.make.parent_serial.should == "0003"
    end
  end

  describe "class inheritance" do
    before(:each) do
      [InheritanceSpecs::Grandpa, InheritanceSpecs::Dad, InheritanceSpecs::Son].each(&:clear_blueprints!)
    end

    it "should inherit blueprinted attributes from the parent class" do
      InheritanceSpecs::Dad.blueprint do
        name { "Fred" }
      end
      InheritanceSpecs::Son.blueprint { }
      InheritanceSpecs::Son.make.name.should == "Fred"
    end

    it "should override blueprinted attributes in the child class" do
      InheritanceSpecs::Dad.blueprint do
        name { "Fred" }
      end
      InheritanceSpecs::Son.blueprint do
        name { "George" }
      end
      InheritanceSpecs::Dad.make.name.should == "Fred"
      InheritanceSpecs::Son.make.name.should == "George"
    end

    it "should inherit from blueprinted attributes in ancestor class" do
      InheritanceSpecs::Grandpa.blueprint do
        name { "Fred" }
      end
      InheritanceSpecs::Son.blueprint { }
      InheritanceSpecs::Grandpa.make.name.should == "Fred"
      lambda { InheritanceSpecs::Dad.make }.should raise_error(RuntimeError)
      InheritanceSpecs::Son.make.name.should == "Fred"
    end

    it "should follow inheritance for named blueprints correctly" do
      InheritanceSpecs::Dad.blueprint do
        name { "John" }
        age  { 56 }
      end
      InheritanceSpecs::Dad.blueprint(:special) do
        name { "Paul" }
      end
      InheritanceSpecs::Son.blueprint(:special) do
        age { 37 }
      end
      InheritanceSpecs::Son.make(:special).name.should == "John"
      InheritanceSpecs::Son.make(:special).age.should == 37
    end
  end

end
