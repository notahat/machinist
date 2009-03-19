require File.dirname(__FILE__) + '/spec_helper'
require 'machinist'


class Person < ActiveRecord::Base
  attr_protected :password
end

class Post < ActiveRecord::Base
  has_many :comments
end

class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :author, :class_name => "Person"
end


describe Machinist do
  
  after{ Person.clear_blueprints! }
  
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
    
    it "should default to calling Sham for an attribute in the blueprint" do
      Sham.clear
      Sham.name { "Fred" }
      Person.blueprint { name }
      Person.make.name.should == "Fred"
    end
    
    it "should let the blueprint override an attribute with a default value" do
      Post.blueprint do
        published { false }
      end
      Post.make.published?.should be_false
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
      Person.blueprint { id 12345 }
      Person.make.id.should == 12345
    end
    
    it "should allow setting the type attribute in a blueprint" do
      Person.blueprint { type "Person" }
      Person.make.type.should == "Person"
    end
    
    describe "for named blueprints" do
      before do
        @block_called = false
        Person.blueprint do
          name  { "Fred" }
          admin { @block_called = true; false }
        end
        Person.blueprint(:admin) do
          admin { true }
        end
        @person = Person.make(:admin)
      end
      
      it "should override an attribute from the parent blueprint in the child blueprint" do
        @person.admin.should == true
      end
      
      it "should not call the block for an attribute from the parent blueprint if that attribute is overridden in the child" do
        @block_called.should be_false
      end
      
      it "should set an attribute defined in the parent blueprint" do
        @person.name.should == "Fred"
      end
    end
  
  end # make method
  
  
  describe "ActiveRecord support" do
    
    describe "make method" do
      it "should save the constructed object" do
        Person.blueprint { }
        person = Person.make
        person.should_not be_new_record
      end
    
      it "should create an object through belongs_to association" do
        Post.blueprint { }
        Comment.blueprint { post }
        Comment.make.post.class.should == Post
      end
    
      it "should create an object through belongs_to association with a class_name attribute" do
        Person.blueprint { }
        Comment.blueprint { author }
        Comment.make.author.class.should == Person
      end

      describe "on a has_many association" do
        before do 
          Post.blueprint { }
          Comment.blueprint { post }
          @post = Post.make
          @comment = @post.comments.make
        end
      
        it "should save the created object" do
          @comment.should_not be_new_record
        end
      
        it "should set the parent association on the created object" do
          @comment.post.should == @post
        end
      end
    end
  
    describe "plan method" do
      it "should not save the constructed object" do
        person_count = Person.count
        Person.blueprint { }
        person = Person.plan
        Person.count.should == person_count
      end
    
      it "should create an object through a belongs_to association, and return its id" do
        Post.blueprint { }
        Comment.blueprint { post }
        post_count = Post.count
        comment = Comment.plan
        Post.count.should == post_count + 1
        comment[:post].should be_nil
        comment[:post_id].should_not be_nil
      end
    
      describe "on a has_many association" do
        before do
          Post.blueprint { }
          Comment.blueprint do
            post
            body { "Test" }
          end
          @post = Post.make
          @post_count = Post.count
          @comment = @post.comments.plan
        end
      
        it "should not include the parent in the returned hash" do
          @comment[:post].should be_nil
          @comment[:post_id].should be_nil
        end
      
        it "should not create an extra parent object" do
          Post.count.should == @post_count
        end
      end
    end
  
    describe "make_unsaved method" do
      it "should not save the constructed object" do
        Person.blueprint { }
        person = Person.make_unsaved
        person.should be_new_record
      end
    
      it "should not save associated objects" do
        Post.blueprint { }
        Comment.blueprint { post }
        comment = Comment.make_unsaved
        comment.post.should be_new_record
      end
    
      it "should save objects made within a passed-in block" do
        Post.blueprint { }
        Comment.blueprint { }
        comment = nil
        post = Post.make_unsaved { comment = Comment.make }
        post.should be_new_record
        comment.should_not be_new_record
      end
    end
    
    describe "named_blueprint method" do
      it "should list all the named blueprints" do
        Person.blueprint(:foo){}
        Person.blueprint(:bar){}
        Person.named_blueprints.to_set.should == [:foo, :bar].to_set
      end
      
      it "should not list master blueprint" do
        Person.blueprint(:foo){}
        Person.blueprint {} # master
        Person.named_blueprints.should == [:foo]
      end
    end
    
    describe "clear_blueprints! method" do
      it "should clear the list of blueprints" do
        Person.blueprint(:foo){}
        Person.clear_blueprints!
        Person.named_blueprints.should == []
      end
      
      it "should clear master blueprint too" do
        Person.blueprint(:foo) {}
        Person.blueprint {} # master
        Person.clear_blueprints!
        lambda { Person.make }.should raise_error(RuntimeError)
      end
    end
    
  end # ActiveRecord support
  
end
