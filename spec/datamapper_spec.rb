require File.dirname(__FILE__) + '/spec_helper'
require 'support/datamapper_environment'

describe Machinist::DataMapper do
  DM = DataMapperEnvironment

  before(:each) do
    DataMapperEnvironment.empty_database!
  end

  def fake_a_test
    t = DataMapper::Transaction.new
    t.begin
    Machinist.reset_before_test
    yield
    t.rollback
  end

  context "make" do
    it "should return an unsaved object" do
      DM::Post.blueprint { }
      post = DM::Post.make
      post.should be_a(DM::Post)
      post.should be_new
    end
  end

  context "make!" do
    it "should make and save objects" do
      DM::Post.blueprint { }
      post = DM::Post.make!
      post.should be_a(DM::Post)
      post.should_not be_new
    end

    it "should not save an invalid object" do
      DM::User.blueprint { }
      expect { DM::User.make!(:username => "") }.to raise_error
    end

    #Currently not implemented
    #it "should buy objects from the shop" do
      #DM::Post.blueprint { }
      #post_a, post_b = nil, nil
      #fake_a_test { post_a = DM::Post.make! }
      #fake_a_test { post_b = DM::Post.make! }
      #post_a.should == post_b
    #end

    #it "should not buy objects from the shop if caching is disabled" do
      #DM::Post.blueprint { }
      #post_a, post_b = nil, nil
      #fake_a_test { post_a = DM::Post.make! }
      #fake_a_test { post_b = DM::Post.make! }
      #post_a.should_not == post_b
      #Machinist.configuration.cache_objects = true
    #end
  end

  context "associations support" do
    it "should handle belongs_to associations" do
      DM::User.blueprint do
        username { "user_#{sn}" }
      end
      DM::Post.blueprint do
        author
      end
      post = DM::Post.make!
      post.should be_a(DM::Post)
      post.should_not be_new
      post.author.should be_a(DM::User)
      post.author.should_not be_new
    end

    it "should handle has_many associations" do
      DM::Post.blueprint do
        comments(3)
      end
      DM::Comment.blueprint { }
      post = DM::Post.make!
      post.should be_a(DM::Post)
      post.should_not be_new
      post.should have(3).comments
      post.comments.each do |comment|
        comment.should be_a(DM::Comment)
        comment.should_not be_new
      end
    end

    it "should handle habtm associations" do
      DM::Post.blueprint do
        tags(3)
      end
      DM::Tag.blueprint do
        name { "tag_#{sn}" }
      end
      post = DM::Post.make!
      post.should be_a(DM::Post)
      post.should_not be_new
      post.should have(3).tags
      post.tags.each do |tag|
        tag.should be_a(DM::Tag)
        tag.should_not be_new
      end
    end

    it "should handle overriding associations" do
      DM::User.blueprint do
        username { "user_#{sn}" }
      end
      DM::Post.blueprint do
        author { DM::User.make!(:username => "post_author_#{sn}") }
      end
      post = DM::Post.make!
      post.should be_a(DM::Post)
      post.should_not be_new
      post.author.should be_a(DM::User)
      post.author.should_not be_new
      post.author.username.should =~ /^post_author_\d+$/
    end
  end

  context "error handling" do
    it "should raise an exception for an attribute with no value" do
      DM::User.blueprint { username }
      lambda {
        DM::User.make
      }.should raise_error(ArgumentError)
    end
  end

end
