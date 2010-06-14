require File.dirname(__FILE__) + '/spec_helper'
require 'support/active_record_environment'
require 'machinist/active_record'

describe Machinist::Shop do

  before(:each) do
    @shop = Machinist::Shop.new
  end

  def fake_a_test
    ActiveRecord::Base.transaction do
      @shop.reset
      yield
      raise ActiveRecord::Rollback
    end
  end
  
  it "should cache an object" do
    blueprint = Machinist::ActiveRecord::Blueprint.new(Post) { }

    post_a, post_b = nil, nil
    fake_a_test { post_a = @shop.buy(blueprint) }
    fake_a_test { post_b = @shop.buy(blueprint) }

    post_b.should == post_a
  end
  
  it "should cache an object with attributes" do
    blueprint = Machinist::ActiveRecord::Blueprint.new(Post) { }

    post_a, post_b = nil, nil
    fake_a_test { post_a = @shop.buy(blueprint, :title => "Test Title") }
    fake_a_test { post_b = @shop.buy(blueprint, :title => "Test Title") }

    post_b.should == post_a
  end

  it "should cache multiple similar objects" do
    blueprint = Machinist::ActiveRecord::Blueprint.new(Post) { }

    post_a, post_b = nil, nil
    fake_a_test do
      post_a = @shop.buy(blueprint, :title => "Test Title")
      post_b = @shop.buy(blueprint, :title => "Test Title")
      post_b.should_not == post_a
    end

    fake_a_test do
      @shop.buy(blueprint, :title => "Test Title").should == post_a
      @shop.buy(blueprint, :title => "Test Title").should == post_b
      post_c = @shop.buy(blueprint, :title => "Test Title")
      post_c.should_not == post_a
      post_c.should_not == post_b
    end
  end
  
  it "should ensure future copies of a cached object do not reflect changes to the original" do
    blueprint = Machinist::ActiveRecord::Blueprint.new(Post) { }

    post_a, post_b = nil, nil
    fake_a_test do
      post_a = @shop.buy(blueprint, :title => "Test Title")
      post_a.title = "Changed Title"
      post_a.save!
    end
    fake_a_test { post_b = @shop.buy(blueprint, :title => "Test Title") }

    post_b.title.should == "Test Title"
  end

  # it "should cache multiple objects with the same class and attributes" do
  #   post_a = Post.make(:title => "Test Title")
  #   post_b = Post.make(:title => "Test Title")
  # 
  #   @shop.reset
  #   post_c = Post.make(:title => "Test Title")
  #   post_c.duped_from.should == post_a.duped_from
  #   post_c.title.should == "Test Title"
  #   post_d = Post.make(:title => "Test Title")
  #   post_d.duped_from.should == post_b.duped_from
  #   post_d.title.should == "Test Title"
  # end
  # 
  # it "should not confuse objects with different attributes" do
  #   post_a = Post.make(:title => "Title A")
  #   post_a.should be_a(Post)
  #   post_a.title.should == "Title A"
  # 
  #   @shop.reset
  #   post_b = Post.make(:title => "Title B")
  #   post_b.duped_from.should_not == post_a.duped_from
  #   post_b.title.should == "Title B"
  # end
  # 
  # it "should not confuse objects of different classes" do
  #   post = Post.make(:title => "Test Title")
  #   post.should be_a(Post)
  #   post.title.should == "Test Title"
  # 
  #   @shop.reset
  #   comment = Comment.make(:author => "Test Author")
  #   comment.should be_a(Comment)
  #   comment.author.should == "Test Author"
  # end
  
end
