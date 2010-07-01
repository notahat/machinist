require File.dirname(__FILE__) + '/spec_helper'

module MachinableSpecs
  class Post
    extend Machinist::Machinable
    attr_accessor :title, :body, :comments
  end

  class Comment
    extend Machinist::Machinable
    attr_accessor :post, :title
  end
end

describe Machinist::Machinable do

  before(:each) do
    MachinableSpecs::Post.clear_blueprints!
  end

  it "should make an object" do
    MachinableSpecs::Post.blueprint do
      title { "First Post" }
    end

    post = MachinableSpecs::Post.make
    post.should be_a(MachinableSpecs::Post)
    post.title.should == "First Post"
  end

  it "should make an object from a named blueprint" do
    MachinableSpecs::Post.blueprint do
      title { "First Post" }
      body  { "Woot!" }
    end

    MachinableSpecs::Post.blueprint(:extra) do
      title { "Extra!" }
    end

    post = MachinableSpecs::Post.make(:extra)
    post.should be_a(MachinableSpecs::Post)
    post.title.should == "Extra!"
    post.body.should == "Woot!"
  end

  it "should make an array of objects" do
    MachinableSpecs::Post.blueprint do
      title { "First Post" }
    end

    posts = MachinableSpecs::Post.make(3)
    posts.should be_an(Array)
    posts.should have(3).elements
    posts.each do |post|
      post.should be_a(MachinableSpecs::Post)
      post.title.should == "First Post"
    end
  end

  it "should make array attributes from the blueprint" do
    MachinableSpecs::Comment.blueprint { }
    MachinableSpecs::Post.blueprint do 
      comments(3) { MachinableSpecs::Comment.make }
    end

    post = MachinableSpecs::Post.make
    post.comments.should be_a(Array)
    post.comments.should have(3).elements
    post.comments.each do |comment|
      comment.should be_a(MachinableSpecs::Comment)
    end
  end

  it "should fail without a blueprint" do
    expect do
      MachinableSpecs::Post.make
    end.should raise_error(Machinist::NoBlueprintError) do |exception|
      exception.klass.should == MachinableSpecs::Post
      exception.name.should  == :master
    end

    expect do
      MachinableSpecs::Post.make(:some_name)
    end.should raise_error(Machinist::NoBlueprintError) do |exception|
      exception.klass.should == MachinableSpecs::Post
      exception.name.should  == :some_name
    end
  end

  it "should fail when calling make! on an unsavable object" do
    MachinableSpecs::Post.blueprint { }

    expect do
      MachinableSpecs::Post.make!
    end.should raise_error(Machinist::BlueprintCantSaveError) do |exception|
      exception.blueprint.klass.should == MachinableSpecs::Post
    end
  end

end
