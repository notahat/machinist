Machinist
=========

*Fixtures aren't fun. Machinist is.*

Machinist lets you construct test data on the fly, but instead of doing this:

    describe Comment do
      before do
        @user = User.create!(:name => "Test User")
        @post = Post.create!(:title => "Test Post", :author => @user, :body => "Lorem ipsum...")
        @comment = Comment.create!(
          :post => @post, :author_name => "Test Commenter", :author_email => "commenter@example.com",
          :spam => true
        )
      end
    
      it "should not include comments marked as spam in the without_spam named scope" do
        Comment.without_spam.should_not include(@comment)
      end
    end
  
you can just do this:

    describe Comment do
      before do
        @comment = Comment.make(:spam => true)
      end
    
      it "should not include comments marked as spam in the without_spam named scope" do
        Comment.without_spam.should_not include(@comment)
      end
    end
  
Machinist generates data for the fields you don't care about, and constructs any necessary associated objects.

You tell Machinist how to do this with blueprints:

    require 'faker'
  
    Sham.name  { Faker::Name.name }
    Sham.email { Faker::Internet.email }
    Sham.title { Faker::Lorem.sentence }
    Sham.body  { Faker::Lorem.paragraph }
  
    User.blueprint do
      name { Sham.name }
    end
  
    Post.blueprint do
      title  { Sham.title }
      author { User.make }
      body   { Sham.body }
    end
  
    Comment.blueprint do
      post
      author_name  { Sham.name }
      author_email { Sham.email }
      body         { Sham.body }
    end


Installation
------------

Install the plugin:

    ./script/plugin install git://github.com/notahat/machinist.git
  
Create a blueprints.rb in your test (or spec) directory, and require it in your test\_helper.rb (or spec\_helper.rb):

    require File.expand_path(File.dirname(__FILE__) + "/blueprints")

Set Sham to reset before each test. In the `class Test::Unit::TestCase` block in your test\_helper.rb, add:
    
    setup { Sham.reset }
    
or, if you're on RSpec, in the `Spec::Runner.configure` block in your spec\_helper.rb, add:

    config.before(:each) { Sham.reset }
    
    
Sham - Generating Attribute Values
----------------------------------

Sham lets you generate random but repeatable unique attributes values.

For example, you could define a way to generate random names as:

    Sham.name { (1..10).map { ('a'..'z').to_a.rand } }

Then, to generate a name, call:

    Sham.name

So why not just define a method? Sham ensures two things for you:

1. You get the same sequence of values each time your test is run
2. You don't get any duplicate values
    
Sham works very well with the excellent [Faker gem](http://faker.rubyforge.org/) by Benjamin Curtis. Using this, a much nicer way to generate names is:
    
    Sham.name { Faker::Name.name }
    
Sham also supports generating numbered sequences if you prefer.

    Sham.name {|index| "Name #{index}" }
    
If you want to allow duplicate values for a sham, you can pass the `:unique` option:

    Sham.coin_toss(:unique => false) { rand(2) == 0 : 'heads' : 'tails' }


Blueprints - Generating ActiveRecord Objects
--------------------------------------------

A blueprint describes how to build a generic object for an ActiveRecord model. The idea is that you let the blueprint take care of constructing all the objects and attributes that you don't care about in your test, leaving you to focus on the just the things that you're testing.

A simple blueprint might look like this:

    Comment.blueprint do
      body "A comment!"
    end

Once that's defined, you can construct a comment from this blueprint with:
    
    Comment.make
    
Machinist calls `save!` on your ActiveRecord model to create the comment, so it will throw an exception if the blueprint doesn't pass your validations. It also calls `reload` after the `save!`.

You can override values defined in the blueprint by passing parameters to make:

    Comment.make(:body => "A different comment!")
    
Rather than providing a constant value for an attribute, you can use Sham to generate a value for each new object:

    Sham.body { Faker::Lorem.paragraph }
    Comment.blueprint do
      body { Sham.body }
    end
    
Notice the curly braces around `Sham.body`. If you call `Comment.make` with your own body attribute, this block will not be executed.

You can use this same syntax to generate associated objects:
    
    Comment.blueprint do
      post { Post.make }
    end
    
If the associated model has the same name as the field, you can abbreviate this to:
    
    Comment.blueprint do
      post
    end
    
You can refer to already assigned attributes when constructing a new attribute:
    
    Comment.blueprint do
      post
      body { "Comment on " + post.name }
    end
    
You can also override associated objects when calling make:

    post = Post.make
    3.times { Comment.make(:post => post) }

It's common to need to construct an object with particular attributes, or a particular object graph, in a number of tests. The best way to abstract out the construction is to put something like this in your blueprints.rb:

    class Post
      def self.make_with_comments(attributes = {})
        Post.make(attributes) do |post|
          3.times { Comment.make(:post => post) }
        end
      end
    end
    
Note that make can take a block, into which it will pass the newly constructed object.

If you want to generate an object graph without saving to the database, use make\_unsaved:

    Comment.make_unsaved
    
This will generate both the Comment and the associated Post without saving either.


Credits
-------

Written by [Pete Yandell](http://notahat.com/).
    
Contributors:

- [Roland Swingler](http://github.com/knaveofdiamonds)

Thanks to Thoughtbot's [Factory Girl](http://github.com/thoughtbot/factory_girl/tree/master). Machinist was written because I loved the idea behind Factory Girl, but I thought the philosophy wasn't quite right, and I hated the syntax.

---
    
Copyright (c) 2008 Peter Yandell, released under the MIT license
