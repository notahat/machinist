require File.dirname(__FILE__) + '/spec_helper'
require 'machinist/data_mapper'
require 'ruby-debug'

module MachinistDataMapperSpecs
  
  class Person
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :type, String
    property :password, String
    property :admin, Boolean, :default => false
  end

  class Post
    include DataMapper::Resource
    property :id, Serial
    property :title, String
    property :body, Text
    property :published, Boolean, :default => true
    has n, :comments
  end

  class Comment
    include DataMapper::Resource
    property :id, Serial
    property :post_id, Integer
    property :author_id, Integer
    belongs_to :post
    belongs_to :author, :class_name => "Person", :child_key => [:author_id]
  end

  describe Machinist, "DataMapper adapter" do  
    before(:suite) do
      DataMapper.setup(:default, "sqlite3::memory:")
      DataMapper.auto_migrate!
    end

    before(:each) do
      Person.clear_blueprints!
      Post.clear_blueprints!
      Comment.clear_blueprints!
    end

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

      it "should raise an exception if the object can't be saved"
    end

  end
end

