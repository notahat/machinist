Machinist
=========

*Fixtures aren't fun. Machinist is.*

Machinist lets you construct test data on the fly, but instead of doing this:

    describe Comment do
      before do
        @user = User.create!(:name => "Test User", :email => "user@example.com")
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
  
Machinist generates data for the fields you don't care about, and constructs any necessary associated objects, leaving you to only specify the fields you *do* care about in your tests.

You tell Machinist how to do this with blueprints:

    require 'faker'
  
    Sham.name  { Faker::Name.name }
    Sham.email { Faker::Internet.email }
    Sham.title { Faker::Lorem.sentence }
    Sham.body  { Faker::Lorem.paragraph }
  
    User.blueprint do
      name
      email
    end
  
    Post.blueprint do
      title
      author
      body
    end
  
    Comment.blueprint do
      post
      author_name  { Sham.name }
      author_email { Sham.email }
      body
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
    
### Installing as a Gem

If you'd prefer, you can install Machinist as a gem:

    sudo gem install notahat-machinist --source http://gems.github.com
    
From there, create the blueprints.rb file as described above, and make sure you require machinist and sham.

    
Sham - Generating Attribute Values
----------------------------------

Sham lets you generate random but repeatable unique attributes values.

For example, you could define a way to generate random names as:

    Sham.name { (1..10).map { ('a'..'z').to_a.rand } }

Then, to generate a name, call:

    Sham.name

So why not just define a helper method to do this? Sham ensures two things for you:

1. You get the same sequence of values each time your test is run
2. You don't get any duplicate values
    
Sham works very well with the excellent [Faker gem](http://faker.rubyforge.org/) by Benjamin Curtis. Using this, a much nicer way to generate names is:
    
    Sham.name { Faker::Name.name }
    
Sham also supports generating numbered sequences if you prefer.

    Sham.name {|index| "Name #{index}" }
    
If you want to allow duplicate values for a sham, you can pass the `:unique` option:

    Sham.coin_toss(:unique => false) { rand(2) == 0 ? 'heads' : 'tails' }
    
You can create a bunch of sham definitions in one hit like this:

    Sham.define do
      title { Faker::Lorem.words(5).join(' ') }
      name  { Faker::Name.name }
      body  { Faker::Lorem.paragraphs(3).join("\n\n") }
    end


Blueprints - Generating ActiveRecord Objects
--------------------------------------------

A blueprint describes how to generate an ActiveRecord object. The idea is that you let the blueprint take care of making up values for attributes that you don't care about in your test, leaving you to focus on the just the things that you're testing.

A simple blueprint might look like this:

    Post.blueprint do
      title  { Sham.title }
      author { Sham.name }
      body   { Sham.body }
    end

You can then construct a Post from this blueprint with:
    
    Post.make
    
When you call `make`, Machinist calls Post.new, then runs through the attributes in your blueprint, calling the block for each attribute to generate a value. It then calls `save!` and `reload` on the Post.

You can override values defined in the blueprint by passing a hash to make:

    Post.make(:title => "A Specific Title")
    
`make` doesn't call the blueprint blocks of any attributes that are passed in.
    
If you don't supply a block for an attribute in the blueprint, Machinist will look for a Sham definition with the same name as the attribute, so you can shorten the above blueprint to:

    Post.blueprint do
      title
      author { Sham.name }
      body
    end
    
If you want to generate an object without saving it to the database, replace `make` with `make_unsaved`. (`make_unsaved` also ensures that any associated objects that need to be generated are not saved. See the section on associations below.)
    

### Belongs\_to Associations

You can generate an associated object like this:
    
    Comment.blueprint do
      post { Post.make }
    end
    
Calling `Comment.make` will construct a Comment and its associated Post, and save both.

If you want to override the value for post when constructing the comment, you can:

    post = Post.make(:title => "A particular title)
    comment = Comment.make(:post => post)
    
Machinist will not call the blueprint block for the post attribute, so this won't generate two posts.
    
Machinist is smart enough to look at the association and work out what sort of object it needs to create, so you can shorten the above blueprint to:
    
    Comment.blueprint do
      post
    end
    
You can refer to already assigned attributes when constructing a new attribute:
    
    Comment.blueprint do
      post
      body { "Comment on " + post.title }
    end
    
    
### Other Associations

For has\_many and has\_and\_belongs\_to\_many associations, ActiveRecord insists that the object be saved before any associated objects can be saved. That means you can't generate the associated objects from within the blueprint.

The simplest solution is to write a test helper:

    def make_post_with_comments(attributes = {})
      post = Post.make(attributes)
      3.times { post.comments.make }
      post
    end

Note here that you can call `make` on a has\_many association.

Make can take a block, into which it passes the constructed object, so the above can be written as:

    def make_post_with_comments
      Post.make(attributes) do |post|
        3.times { post.comments.make }
      end
    end


### Using Blueprints in Rails Controller Tests

The `plan` method behaves like `make`, except it returns a hash of attributes, and doesn't save the object. This is useful for passing in to controller tests:

    test "should create post" do
      assert_difference('Post.count') do
        post :create, :post => Post.plan
      end
      assert_redirected_to post_path(assigns(:post))
    end
    
`plan` will save any associated objects. In this example, it will create an Author, and it knows that the controller expects an `author_id` attribute, rather than an `author` attribute, and makes this translation for you.
    
You can also call plan on has\_many associations, making it easy to test nested controllers:

    test "should create comment" do
      post = Post.make
      assert_difference('Comment.count') do
        post :create, :post_id => post.id, :comment => post.comments.plan
      end
      assert_redirected_to post_comment_path(post, assigns(:comment))
    end


### Named Blueprints

Named blueprints let you define variations on an object. For example, suppose some of your Users are administrators:

    User.blueprint do
      name
      email
    end
    
    User.blueprint(:admin) do
      name  { Sham.name + " (admin)" }
      admin { true }
    end

Calling:

    User.make(:admin)

will use the `:admin` blueprint.

Named blueprints call the default blueprint to set any attributes not specifically provided, so in this example the `email` attribute will still be generated even for an admin user.


FAQ
---
    
### My blueprint is giving me really weird errors. Any ideas?

If your object has an attribute that happens to correspond to a Ruby standard function, it won't work properly in a blueprint. 

For example:

    OpeningHours.blueprint do
      open { Time.now }
    end
    
This will result in Machinist attempting to run ruby's open command. To work around this use self.open instead.

    OpeningHours.blueprint do
      self.open { Time.now }
    end


Credits
-------

Written by [Pete Yandell](http://notahat.com/).
    
Contributors:

- [Clinton Forbes](http://github.com/clinton)
- [Jon Guymon](http://github.com/gnarg)
- [Evan David Light](http://github.com/elight)
- [Kyle Neath](http://github.com/kneath)
- [T.J. Sheehy](http://github.com/tjsheehy)
- [Roland Swingler](http://github.com/knaveofdiamonds)
- [Matt Wastrodowski](http://github.com/towski)
- [Ian White](http://github.com/ianwhite)

Thanks to Thoughtbot's [Factory Girl](http://github.com/thoughtbot/factory_girl/tree/master). Machinist was written because I loved the idea behind Factory Girl, but I thought the philosophy wasn't quite right, and I hated the syntax.

---
    
Copyright (c) 2008 Peter Yandell, released under the MIT license
