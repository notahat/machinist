require File.dirname(__FILE__) + '/spec_helper'
require 'machinist/adapters/object'

class Post
  attr_accessor :title, :body, :comments
end

class Comment
  attr_accessor :post, :title
end

describe Machinist::Machinable do

  before(:each) do
    Post.clear_blueprints!
  end

  it "should make an object" do
    Post.blueprint do
      title { "First Post" }
    end

    post = Post.make
    post.should be_a(Post)
    post.title.should == "First Post"
  end

  it "should make an object from a named blueprint" do
    Post.blueprint do
      title { "First Post" }
      body  { "Woot!" }
    end

    Post.blueprint(:extra) do
      title { "Extra!" }
    end

    post = Post.make(:extra)
    post.should be_a(Post)
    post.title.should == "Extra!"
    post.body.should == "Woot!"
  end

  it "should make an array of objects" do
    Post.blueprint do
      title { "First Post" }
    end

    posts = Post.make(3)
    posts.should be_an(Array)
    posts.should have(3).elements
    posts.each do |post|
      post.should be_a(Post)
      post.title.should == "First Post"
    end
  end

  it "should guess the class to make for an attribute" do
    Post.blueprint { }
    blueprint = Machinist::Blueprint.new { post }

    blueprint.make.post.should be_a(Post)
  end

  it "should guess the class to make for a plural attribute" do
    Comment.blueprint { }
    blueprint = Machinist::Blueprint.new { comments 3, :title => "New Title" }

    comments = blueprint.make.comments
    comments.should be_an(Array)
    comments.should have(3).elements
    comments.each do |comment|
      comment.should be_a(Comment)
      comment.title.should == "New Title"
    end
  end

  it "should fail without a blueprint" do
    lambda { Post.make }.should raise_error("No blueprint defined")
    lambda { Post.make(:some_name) }.should raise_error("No blueprint defined")
  end

end
