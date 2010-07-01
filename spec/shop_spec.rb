require File.dirname(__FILE__) + '/spec_helper'
require 'support/active_record_environment'

describe Machinist::Shop do

  before(:each) do
    @shop = Machinist::Shop.new
  end

  def fake_a_test
    ActiveRecord::Base.transaction do
      @shop.restock
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
    post_b.should_not equal(post_a)
  end
  
  it "should cache an object with attributes" do
    blueprint = Machinist::ActiveRecord::Blueprint.new(Post) { }

    post_a, post_b = nil, nil
    fake_a_test { post_a = @shop.buy(blueprint, :title => "Test Title") }
    fake_a_test { post_b = @shop.buy(blueprint, :title => "Test Title") }

    post_b.should == post_a
    post_b.should_not equal(post_a)
  end

  it "should not confuse objects with different blueprints" do
    blueprint_a = Machinist::ActiveRecord::Blueprint.new(Post) { }
    blueprint_b = Machinist::ActiveRecord::Blueprint.new(Post) { }

    post_a, post_b = nil, nil
    fake_a_test { post_a = @shop.buy(blueprint_a) }
    fake_a_test { post_b = @shop.buy(blueprint_b) }

    post_b.should_not == post_a
  end

  it "should not confuse objects with the same blueprint but different attributes" do
    blueprint = Machinist::ActiveRecord::Blueprint.new(Post) { }

    post_a, post_b = nil, nil
    fake_a_test { post_a = @shop.buy(blueprint, :title => "A Title") }
    fake_a_test { post_b = @shop.buy(blueprint, :title => "Not A Title") }

    post_b.should_not == post_a
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

end
