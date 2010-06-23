require File.dirname(__FILE__) + '/spec_helper'

describe Machinist::Strategies::PassAttributesToNew do

  it "should construct an object by passing attributes to new" do
    klass = Class.new do
      extend Machinist::Machinable

      def initialize(attributes = {})
        @title = attributes[:title]
      end

      attr_reader :title
    end

    klass.blueprint(:strategy => :pass_attributes_to_new) do
      title { "A Title" }
    end

    klass.make.title.should == "A Title"
  end
        

end

  
