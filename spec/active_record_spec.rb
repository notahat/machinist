require File.dirname(__FILE__) + '/spec_helper'
require 'support/active_record_environment'

describe Machinist::ActiveRecord do
  include ActiveRecordEnvironment

  before(:each) do
    Machinist::Shop.instance.reset!
    empty_database!
  end

  def fake_a_test
    ActiveRecord::Base.transaction do
      Machinist.reset_before_test
      yield
      raise ActiveRecord::Rollback
    end
  end

  context "make" do
    it "should return an unsaved object" do
      Post.blueprint { }
      post = Post.make
      post.should be_a(Post)
      post.should be_new_record
    end
  end

  context "make!" do
    it "should make and save objects" do
      Post.blueprint { }
      post = Post.make!
      post.should be_a(Post)
      post.should_not be_new_record
    end

    it "should raise an exception for an invalid object" do
      User.blueprint { }
      lambda {
        User.make!(:username => "")
      }.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should buy objects from the shop" do
      Post.blueprint { }
      post_a, post_b = nil, nil
      fake_a_test { post_a = Post.make! }
      fake_a_test { post_b = Post.make! }
      post_a.should == post_b
    end

    it "should not buy objects from the shop if caching is disabled" do
      Machinist.configuration.cache_objects = false
      Post.blueprint { }
      post_a, post_b = nil, nil
      fake_a_test { post_a = Post.make! }
      fake_a_test { post_b = Post.make! }
      post_a.should_not == post_b
      Machinist.configuration.cache_objects = true 
    end
  end

  context "associations support" do
    it "should handle belongs_to associations" do
      User.blueprint do
        username { "user_#{sn}" }
      end
      Post.blueprint do
        author
      end
      post = Post.make!
      post.should be_a(Post)
      post.should_not be_new_record
      post.author.should be_a(User)
      post.author.should_not be_new_record
    end

    it "should handle has_many associations" do
      Post.blueprint do
        comments(3)
      end
      Comment.blueprint { }
      post = Post.make!
      post.should be_a(Post)
      post.should_not be_new_record
      post.should have(3).comments
      post.comments.each do |comment|
        comment.should be_a(Comment)
        comment.should_not be_new_record
      end
    end

    it "should handle habtm associations" do
      Post.blueprint do
        tags(3)
      end
      Tag.blueprint do
        name { "tag_#{sn}" }
      end
      post = Post.make!
      post.should be_a(Post)
      post.should_not be_new_record
      post.should have(3).tags
      post.tags.each do |tag|
        tag.should be_a(Tag)
        tag.should_not be_new_record
      end
    end

    it "should handle overriding associations" do
      User.blueprint do
        username { "user_#{sn}" }
      end
      Post.blueprint do
        author { User.make!(:username => "post_author_#{sn}") }
      end
      post = Post.make!
      post.should be_a(Post)
      post.should_not be_new_record
      post.author.should be_a(User)
      post.author.should_not be_new_record
      post.author.username.should =~ /^post_author_\d+$/
    end
  end

  context "error handling" do
    it "should raise an exception for an attribute with no value" do
      User.blueprint { username }
      lambda {
        User.make
      }.should raise_error(ArgumentError)
    end
  end

end
