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

  it "should define a simple blueprint" do
    MixinSpecs::Post.blueprint do
      title { "First Post" }
    end

    post = MixinSpecs::Post.make
    post.should be_a(MixinSpecs::Post)
    post.title.should == "First Post"
  end

end
