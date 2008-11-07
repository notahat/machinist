require File.dirname(__FILE__) + '/spec_helper'
require 'machinist'

class Base
  include Machinist::ActiveRecordExtensions
  
  def save!;  @saved = true;          end
  def reload; @reloaded = true; self; end

  def saved?;    @saved;    end
  def reloaded?; @reloaded; end
end

class Post < Base
  attr_accessor :title
  attr_accessor :body
end

class Comment < Base
  attr_accessor :post
  attr_accessor :author
  attr_accessor :body
end

Post.blueprint do
  title "An Example Post"
  body  { "The quick brown fox." }
end

Comment.blueprint do
  post
  author "Fred Bloggs"
  body   "Just a comment."
end
  
describe Machinist do
  describe "make methd" do
    before do
      @post = Post.make
    end
    
    it "should set a field from a constant in the blueprint" do
      @post.title.should == "An Example Post"
    end
  
    it "should set a field from a block in the blueprint" do
      @post.body.should == "The quick brown fox."
    end
    
    it "should save the object" do
      @post.should be_saved
    end
    
    it "should reload the object" do
      @post.should be_reloaded
    end
  end
  
  describe "make_unsaved method" do
    before do
      @comment = Comment.make_unsaved
    end
    
    it "should not save the object" do
      @comment.should_not be_saved
    end
    
    it "should not reload the object" do
      @comment.should_not be_reloaded
    end
    
    it "should not save associated objects" do
      @comment.post.should_not be_saved
    end
    
    it "should not reload associated objects" do
      @comment.post.should_not be_reloaded
    end
  end
  
  it "should override a field from the blueprint with a parameter" do
    post = Post.make(:title => "A Different Title")
    post.title.should == "A Different Title"
  end
  
  it "should create an associated object for a field with no arguments in the blueprint" do
    comment = Comment.make
    comment.post.should_not be_nil
  end
  
  it "should allow passing a block to make" do
    comments = nil
    post = Post.make do |post|
      comments = (1..3).map { Comment.make(:post => post) }
    end
    post.should be_an_instance_of(Post)
    comments.should_not be_nil
    comments.each {|comment| comment.post.should == post }
  end
  
  it "should not nerf make within a block passed to make_unsaved" do
    comment = nil
    post = Post.make_unsaved do |post|
      comment = Comment.make(:post => post)
    end
    post.should_not be_saved
    comment.should  be_saved
    comment.post.should == post
  end
end
