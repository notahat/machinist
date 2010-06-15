require File.dirname(__FILE__) + '/spec_helper'
require 'support/active_record_environment'

describe Machinist::Collection do
  include ActiveRecordEnvironment

  before(:each) do
    Machinist::Collection.clear_blueprints!
    reset_active_record_stuff!
    Machinist::Shop.reset_warehouse!
  end

  it "should create a bunch of objects" do
    User.blueprint do
      username { "user_#{sn}" }
    end

    Post.blueprint do
      author
      title  { "Post #{sn}" }
      body   { "Lorem ipsum..." }
    end

    Comment.blueprint do
      post
      body { "Lorem ipsum..." }
    end
    
    Machinist::Collection.blueprint(:stuff) do
      user
      posts(3, :author => user)
      posts.each do |post|
        comments(3, :post => post)
      end
    end

    stuff = Machinist::Collection.make(:stuff)

    stuff.user.should be_a(User)

    stuff.posts.should have(3).elements
    stuff.posts.each do |post|
      post.should be_a(Post)
      post.author.should == stuff.user
    end

    stuff.comments.should have(9).elements
    stuff.comments.each do |comment|
      comment.should be_a(Comment)
    end
    stuff.comments[0..2].each do |comment|
      comment.post.should == stuff.posts[0]
    end
    stuff.comments[3..5].each do |comment|
      comment.post.should == stuff.posts[1]
    end
    stuff.comments[6..8].each do |comment|
      comment.post.should == stuff.posts[2]
    end
  end

end
