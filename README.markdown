# Machinist 2

*Fixtures aren't fun. Machinist is.*

[What's new in Machinist 2](http://wiki.github.com/notahat/machinist/machinist-2)

- [Home page](http://github.com/notahat/machinist/tree/machinist2)
- [Documentation](http://wiki.github.com/notahat/machinist/)
- [Google group](http://groups.google.com/group/machinist-users)
- [Issue tracker](http://github.com/notahat/machinist/issues)


# Introduction

Machinist makes it easy to create test data within your tests. It generates
data for the fields you don't care about, and constructs any necessary
associated objects, leaving you to specify only the fields you *do* care about
in your tests. For example:

    describe Comment do
      it "should not include spam in the without_spam scope" do
        # This will make a Comment, a Post, and a User (the author of
        # the Post), and generate values for all their attributes:
        spam = Comment.make!(:spam => true)

        Comment.without_spam.should_not include(spam)
      end
    end

You tell Machinist how to do this with blueprints:

    require 'machinist/active_record'

    User.blueprint do
      username { "user#{sn}" }  # Each user gets a unique serial number.
    end
 
    Post.blueprint do
      author
      title  { "Post #{sn}" }
      body   { "Lorem ipsum..." }
    end

    Comment.blueprint do
      post
      email { "commenter-#{sn}@example.com" }
      body  { "Lorem ipsum..." }
    end

Read the [documentation](http://wiki.github.com/notahat/machinist/) for more info.


# Installation

So far the generators only work with Rails 3 and RSpec. This will be fixed soon.

## Rails 3

Edit your app's `Gemfile` and, inside the `group :test` section, add:

    gem 'machinist', '2.0.0.head', :git => 'git://github.com/notahat/machinist.git', :branch => 'machinist2'

Then run:

    bundle install
    rake machinist:install

If you want Machinist to automatically add a blueprint to your blueprints file
whenever you generate a model, add the following to your
`config/application.rb` in the `config.generators` section:

    g.fixture_replacement :machinist


## Rails 2

Machinist 2 isn't a gem yet, so the easiest thing to do is install it as a
plugin:

    ruby /script/plugin install git://github.com/notahat/machinist.git -r machinist2

### ...with RSpec

Create a `blueprints.rb` file to hold your blueprints in your `spec/support`
directory.  It should start with:

    require 'machinist/active_record'

In your `spec/spec_helper.rb`, add this inside the `Spec::Runner.configure` block:

    config.before(:each) { Machinist.reset_before_test }

### ...with Test::Unit

Create a `blueprints.rb` file to hold your blueprints in your `test` directory.
It should start with:

    require 'machinist/active_record'

In your `test/test_helper.rb`, add this to the requires at the top of the file:

    require File.expand_path(File.dirname(__FILE__) + "/blueprints")

and add this inside `class ActiveSupport::TestCase`:

    setup { Machinist.reset_before_test }


## Contributors

Machinist is maintained by Pete Yandell ([pete@notahat.com](mailto:pete@notahat.com), [@notahat](http://twitter.com/notahat))

Other contributors include:

[Marcos Arias](http://github.com/yizzreel),
[Jack Dempsey](http://github.com/jackdempsey),
[Clinton Forbes](http://github.com/clinton),
[Perryn Fowler](http://github.com/perryn),
[Niels Ganser](http://github.com/Nielsomat),
[Jeremy Grant](http://github.com/jeremygrant),
[Jon Guymon](http://github.com/gnarg),
[James Healy](http://github.com/yob),
[Evan David Light](http://github.com/elight),
[Chris Lloyd](http://github.com/chrislloyd),
[Adam Meehan](http://github.com/adzap),
[Kyle Neath](http://github.com/kneath),
[Lawrence Pit](http://github.com/lawrencepit),
[T.J. Sheehy](http://github.com/tjsheehy),
[Roland Swingler](http://github.com/knaveofdiamonds),
[Gareth Townsend](http://github.com/quamen),
[Matt Wastrodowski](http://github.com/towski),
[Ian White](http://github.com/ianwhite)

Thanks to Thoughtbot's [Factory
Girl](http://github.com/thoughtbot/factory_girl/tree/master). Machinist was
written because I loved the idea behind Factory Girl, but I thought the
philosophy wasn't quite right, and I hated the syntax.
  
