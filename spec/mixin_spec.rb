require File.dirname(__FILE__) + '/spec_helper'
require 'machinist/blueprint'
require 'machinist/lathe'
require 'machinist/mixin'

module MixinSpecs
  class Post
    extend Machinist::Mixin
    attr_accessor :title, :body
  end
end

describe Machinist::Mixin do

  before(:each) do
    MixinSpecs::Post.clear_blueprints!
  end

  it "should define a simple blueprint" do
    MixinSpecs::Post.blueprint do
      title { "First Post" }
    end

    post = MixinSpecs::Post.make
    post.should be_a(MixinSpecs::Post)
    post.title.should == "First Post"
  end

  it "should define a named blueprint" do
    MixinSpecs::Post.blueprint do
      title { "First Post" }
      body  { "Woot!" }
    end

    MixinSpecs::Post.blueprint(:extra) do
      title { "Extra!" }
    end

    post = MixinSpecs::Post.make(:extra)
    post.should be_a(MixinSpecs::Post)
    post.title.should == "Extra!"
    post.body.should == "Woot!"
  end

  it "should raise an error when calling make with a blueprint defined" do
    lambda { MixinSpecs::Post.make             }.should raise_error("No blueprint defined")
    lambda { MixinSpecs::Post.make(:some_name) }.should raise_error("No blueprint defined")
  end

end
