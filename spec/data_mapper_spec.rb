require File.dirname(__FILE__) + '/spec_helper'
require 'support/data_mapper_environment'

module DataMapperModels
  describe Machinist::DataMapper do
    include DataMapperEnvironment

    before(:each) do
      empty_database!
    end

    context "make" do
      it "returns an unsaved object" do
        Post.blueprint { }
        post = Post.make
        post.should be_a(Post)
        post.should be_new
      end
    end

    context "make!" do
      it "makes and saves objects" do
        Post.blueprint { }
        post = Post.make!
        post.should be_a(Post)
        post.should_not be_new
      end

      it "raises an exception for an invalid object" do
        User.blueprint { }
        lambda {
          User.make!(:username => "")
        }.should raise_error
      end
    end

    context "associations support" do
      it "handles belongs_to associations" do
        User.blueprint do
          username { "user_#{sn}" }
        end
        Post.blueprint do
          author
        end
        post = Post.make!
        post.should be_a(Post)
        post.should_not be_new
        post.author.should be_a(User)
        post.author.should_not be_new
      end

      it "handles has_many associations" do
        Post.blueprint do
          comments(3)
        end
        Comment.blueprint { }
        post = Post.make!
        post.should be_a(Post)
        post.should_not be_new
        post.should have(3).comments
        post.comments.each do |comment|
          comment.should be_a(Comment)
          comment.should_not be_new
        end
      end

      it "handles habtm associations" do
        Post.blueprint do
          tags(3)
        end
        Tag.blueprint do
          name { "tag_#{sn}" }
        end
        post = Post.make!
        post.should be_a(Post)
        post.should_not be_new
        post.should have(3).tags
        post.tags.each do |tag|
          tag.should be_a(Tag)
          tag.should_not be_new
        end
      end

      it "handles overriding associations" do
        User.blueprint do
          username { "user_#{sn}" }
        end
        Post.blueprint do
          author { User.make(:username => "post_author_#{sn}") }
        end
        post = Post.make!
        post.should be_a(Post)
        post.should_not be_new
        post.author.should be_a(User)
        post.author.should_not be_new
        post.author.username.should =~ /^post_author_\d+$/
      end
    end

    context "error handling" do
      it "raises an exception for an attribute with no value" do
        User.blueprint { username }
        lambda {
          User.make
        }.should raise_error(ArgumentError)
      end
    end

  end
end
