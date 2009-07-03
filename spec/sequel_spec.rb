require File.dirname(__FILE__) + '/spec_helper'
require 'machinist/sequel'

DB = Sequel.sqlite

DB.create_table :people do
  primary_key :id
  String      :name
  String      :type
  String      :password
  Boolean     :admin
end

DB.create_table :posts do
  primary_key :id
  String      :title
  String      :body
  Boolean     :published
end

DB.create_table :comments do
  primary_key :id
  Integer     :post_id
  Integer     :author_id
end
      
class Person < Sequel::Model
  plugin :validation_helpers
  def validate
    validates_max_length 10, :name, :allow_nil => true
  end
end

class Post < Sequel::Model
  one_to_many :comments
end

class Comment < Sequel::Model
  many_to_one :post
  many_to_one :author, :class => Person, :key => :author_id
end

module MachinistSequelSpecs

  describe Machinist, "Sequel adapter" do
    before(:each) do
      Person.clear_blueprints!
      Post.clear_blueprints!
      Comment.clear_blueprints!
    end

    describe "make method" do
      it "should save constructed object" do
        Person.blueprint {}
        person = Person.make
        person.should_not be_new
      end

      it "should create and object through a many_to_one association" do
        Post.blueprint { }
        Comment.blueprint { post }
        Comment.make.post.class.should == Post
      end
      
      it "should create an object through a belongs_to association with a class_name attribute" do
        Person.blueprint { }
        Comment.blueprint { author }
        Comment.make.author.class.should == Person
      end

      it "should raise an exception if the object can't be saved" do
        Person.blueprint { }
        lambda { Person.make(:name => "More than ten characters") }.should raise_error(Sequel::ValidationFailed)
      end
    end

    describe "plan method" do
      it "should not save the constructed object" do
        lambda {
          Person.blueprint { }
          person = Person.plan
        }.should_not change(Person,:count)
      end

      it "should return a regular attribute in the hash" do
        Post.blueprint { title "Test" }
        post = Post.plan
        post[:title].should == "Test"
      end

      it "should create an object through a many_to_one association, and return its id" do
        Post.blueprint { }
        Comment.blueprint { post }
        lambda {
          comment = Comment.plan
          comment[:post].should be_nil
          comment[:post_id].should_not be_nil
        }.should change(Post, :count).by(1)
      end
    end

    describe "make_unsaved method" do
      it "should not save the constructed object" do
        Person.blueprint { }
        person = Person.make_unsaved
        person.should be_new
      end

      it "should not save associated objects" do
        Post.blueprint { }
        Comment.blueprint { post }
        comment = Comment.make_unsaved
        comment.post.should be_new
      end

      it "should save objects made within a passed-in block" do
        Post.blueprint { }
        Comment.blueprint { }
        comment = nil
        post = Post.make_unsaved { comment = Comment.make }
        post.should be_new
        comment.should_not be_new
      end
    end

  end
end
