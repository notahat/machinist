require File.dirname(__FILE__) + '/spec_helper'

describe Machinist, "exceptions" do

  describe Machinist::BlueprintCantSaveError do
    it "should present the right message" do
      blueprint = Machinist::Blueprint.new(String) { }
      exception = Machinist::BlueprintCantSaveError.new(blueprint)
      exception.message.should == "make! is not supported by blueprints for class String"
    end
  end

  describe Machinist::NoBlueprintError do
    it "should present the right message" do
      exception = Machinist::NoBlueprintError.new(String, :master)
      exception.message.should == "No master blueprint defined for class String"
    end
  end

end
