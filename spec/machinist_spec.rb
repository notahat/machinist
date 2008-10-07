$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'machinist'

class Base
  include Machinist
  
  def save!
    true
  end
  
  def reload
    self
  end
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
  it "should set a field from a constant in the blueprint" do
    post = Post.make
    post.title.should == "An Example Post"
  end
  
  it "should set a field from a block in the blueprint" do
    post = Post.make
    post.body.should == "The quick brown fox."
  end
  
  it "should overrid a field from the blueprint with a parameter" do
    post = Post.make(:title => "A Different Title")
    post.title.should == "A Different Title"
  end
  
  it "should create an associated object for a field with no arguments in the blueprint" do
    comment = Comment.make
    comment.post.should_not be_nil
  end
  
end
