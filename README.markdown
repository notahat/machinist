# Machinist 2

*Fixtures aren't fun. Machinist is.*

And now, Machinist 2 gives you the convenience of Machinist, with the
performance of fixtures.

See the wiki for [upgrade instructions and info on what's
new](http://wiki.github.com/notahat/machinist/machinist-2) in Machinist 2.


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


# Documentation

Still to come!

- Caching
- Serial Numbers
- Accessing Other Attributes
- Associations
- make vs make!


# In The Works

## Not Done Yet

- No `make` method on associations
- No support for ORMs other than ActiveRecord

## In The Planning Stage

- Support for constructing (and caching) complete graphs of objects in one hit
- Easy support for different construction strategies, e.g. generating all the
  attributes and passing them to new as a hash


# Community

You can always find the [latest version on GitHub](http://github.com/notahat/machinist/tree/machinist2).

If you have questions, check out the [Google Group](http://groups.google.com/group/machinist-users).

File bug reports and feature requests in the [issue tracker](http://github.com/notahat/machinist/issues).

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
  
