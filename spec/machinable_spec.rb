require File.dirname(__FILE__) + '/spec_helper'
require 'machinist/blueprint'
require 'machinist/lathe'
require 'machinist/machinable'

module MachinableSpecs
  class Post
    extend Machinist::Machinable
    attr_accessor :title, :body
  end
end

describe Machinist::Machinable do

  before(:each) do
    MachinableSpecs::Post.clear_blueprints!
  end

  it "should define a simple blueprint" do
    MachinableSpecs::Post.blueprint do
      title { "First Post" }
    end

    post = MachinableSpecs::Post.make
    post.should be_a(MachinableSpecs::Post)
    post.title.should == "First Post"
  end

  it "should define a named blueprint" do
    MachinableSpecs::Post.blueprint do
      title { "First Post" }
      body  { "Woot!" }
    end

    MachinableSpecs::Post.blueprint(:extra) do
      title { "Extra!" }
    end

    post = MachinableSpecs::Post.make(:extra)
    post.should be_a(MachinableSpecs::Post)
    post.title.should == "Extra!"
    post.body.should == "Woot!"
  end

  it "should raise an error when calling make with a blueprint defined" do
    lambda { MachinableSpecs::Post.make             }.should raise_error("No blueprint defined")
    lambda { MachinableSpecs::Post.make(:some_name) }.should raise_error("No blueprint defined")
  end

end
