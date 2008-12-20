require File.dirname(__FILE__) + '/spec_helper'
require 'machinist'

# This is a stub version of ActiveRecord that has just enough functionality to
# keep Machinist happy.
class InactiveRecord
  include Machinist::ActiveRecordExtensions

  def initialize(attributes = {})
    self.protected_attributes ||= []
    attributes = attributes.reject {|key, value| protected_attributes.include?(key) }
    attributes.each do |key, value|
      self.send("#{key}=", value)
    end
  end

  class_inheritable_accessor :protected_attributes
    
  def self.attr_protected(attribute)
    self.protected_attributes ||= []
    self.protected_attributes << attribute
  end
  
  def save!;  @saved = true;          end
  def reload; @reloaded = true; self; end

  def saved?;    @saved;    end
  def reloaded?; @reloaded; end
end

class Person < InactiveRecord
  attr_accessor :id
  attr_accessor :name
  attr_accessor :type
  attr_accessor :password
  
  attr_protected :password
end

class Post < InactiveRecord
  attr_accessor :title
  attr_accessor :body
end

class Comment < InactiveRecord
  attr_accessor :post
end

describe Machinist do
  describe "make method" do
    it "should set an attribute on the constructed object from a constant in the blueprint" do
      Person.blueprint do
        name "Fred"
      end
      Person.make.name.should == "Fred"
    end
  
    it "should set an attribute on the constructed object from a block in the blueprint" do
      Person.blueprint do
        name { "Fred" }
      end
      Person.make.name.should == "Fred"
    end
    
    it "should override an attribute from the blueprint with a passed-in attribute" do
      Person.blueprint do
        name "Fred"
      end
      Person.make(:name => "Bill").name.should == "Bill"
    end
    
    it "should allow overridden attribute names to be strings" do
      Person.blueprint do
        name "Fred"
      end
      Person.make("name" => "Bill").name.should == "Bill"
    end
    
    it "should not call a block in the blueprint if that attribute is passed in" do
      block_called = false
      Person.blueprint do
        name { block_called = true; "Fred" }
      end
      Person.make(:name => "Bill").name.should == "Bill"
      block_called.should be_false
    end
    
    it "should save and reload the constructed object" do
      Person.blueprint { }
      person = Person.make
      person.should be_saved
      person.should be_reloaded
    end
    
    it "should create an associated object for an attribute with no arguments in the blueprint" do
      Post.blueprint { }
      Comment.blueprint { post }
      Comment.make.post.class.should == Post
    end
    
    it "should call a passed-in block with the object being constructed" do
      Person.blueprint { }
      block_called = false
      Person.make do |person|
        block_called = true
        person.class.should == Person
      end
      block_called.should be_true
    end
    
    it "should provide access to the object being constructed from within the blueprint" do
      person = nil
      Person.blueprint { person = object }
      Person.make
      person.class.should == Person
    end
    
    it "should allow reading of a previously assigned attribute from within the blueprint" do
      Post.blueprint do
        title "Test"
        body { title }
      end
      Post.make.body.should == "Test"
    end
    
    it "should allow setting a protected attribute in the blueprint" do
      Person.blueprint do
        password "Test"
      end
      Person.make.password.should == "Test"
    end
    
    it "should allow overriding a protected attribute" do
      Person.blueprint do
        password "Test"
      end
      Person.make(:password => "New").password.should == "New"
    end
    
    it "should allow setting the id attribute in a blueprint" do
      Person.blueprint { id "test" }
      Person.make.id.should == "test"
    end
    
    it "should allow setting the type attribute in a blueprint" do
      Person.blueprint { type "test" }
      Person.make.type.should == "test"
    end
  end
  
  describe "make_unsaved method" do
    it "should not save and reload the constructed object" do
      Person.blueprint { }
      person = Person.make_unsaved
      person.should_not be_saved
      person.should_not be_reloaded
    end
    
    it "should not save or reload associated objects" do
      Post.blueprint { }
      Comment.blueprint { post }
      comment = Comment.make_unsaved
      comment.post.should_not be_saved
      comment.post.should_not be_reloaded
    end
    
    it "should save objects made within a passed-in block" do
      Post.blueprint { }
      Comment.blueprint { }
      comment = nil
      post = Post.make_unsaved {|post| comment = Comment.make(:post => post) }
      post.should_not be_saved
      comment.should  be_saved
    end
  end
end
