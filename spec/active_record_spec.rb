require File.dirname(__FILE__) + '/spec_helper'
require 'support/active_record_environment'

describe Machinist::ActiveRecord do
  include ActiveRecordEnvironment
  AR = ActiveRecordEnvironment

  before(:each) do
    empty_database!
  end

  context "make" do
    it "should return an unsaved object" do
      AR::Post.blueprint { }
      post = AR::Post.make
      post.should be_a(AR::Post)
      post.should be_new_record
    end
  end

  context "make!" do
    it "should make and save objects" do
      AR::Post.blueprint { }
      post = AR::Post.make!
      post.should be_a(AR::Post)
      post.should_not be_new_record
    end

    it "should raise an exception for an invalid object" do
      AR::User.blueprint { }
      lambda {
        AR::User.make!(:username => "")
      }.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "associations support" do
    it "should handle belongs_to associations" do
      AR::User.blueprint do
        username { "user_#{sn}" }
      end
      AR::Post.blueprint do
        author
      end
      post = AR::Post.make!
      post.should be_a(AR::Post)
      post.should_not be_new_record
      post.author.should be_a(AR::User)
      post.author.should_not be_new_record
    end

    it "should handle has_many associations" do
      AR::Post.blueprint do
        comments(3)
      end
      AR::Comment.blueprint { }
      post = AR::Post.make!
      post.should be_a(AR::Post)
      post.should_not be_new_record
      post.should have(3).comments
      post.comments.each do |comment|
        comment.should be_a(AR::Comment)
        comment.should_not be_new_record
      end
    end

    it "should handle habtm associations" do
      AR::Post.blueprint do
        tags(3)
      end
      AR::Tag.blueprint do
        name { "tag_#{sn}" }
      end
      post = AR::Post.make!
      post.should be_a(AR::Post)
      post.should_not be_new_record
      post.should have(3).tags
      post.tags.each do |tag|
        tag.should be_a(AR::Tag)
        tag.should_not be_new_record
      end
    end

    it "should handle overriding associations" do
      AR::User.blueprint do
        username { "user_#{sn}" }
      end
      AR::Post.blueprint do
        author { AR::User.make!(:username => "post_author_#{sn}") }
      end
      post = AR::Post.make!
      post.should be_a(AR::Post)
      post.should_not be_new_record
      post.author.should be_a(AR::User)
      post.author.should_not be_new_record
      post.author.username.should =~ /^post_author_\d+$/
    end
  end

  context "error handling" do
    it "should raise an exception for an attribute with no value" do
      AR::User.blueprint { username }
      lambda {
        AR::User.make
      }.should raise_error(ArgumentError)
    end
  end

end
