# Machinist 2

*Fixtures aren't fun. Machinist is.*

Machinist 2 is **still in beta**! Unless you really know what you're doing,
[you probably want Machinist
1](http://github.com/notahat/machinist/tree/1.0-maintenance).

- [Home page](http://github.com/notahat/machinist)
- [What's new in Machinist 2](http://wiki.github.com/notahat/machinist/machinist-2)
- [Installation](http://wiki.github.com/notahat/machinist/installation)
- [Documentation](http://wiki.github.com/notahat/machinist/getting-started)
- [Google group](http://groups.google.com/group/machinist-users)
- [Bug tracker](http://github.com/notahat/machinist/issues)


# Introduction

Machinist makes it easy to create objects within your tests. It generates data
for the attributes you don't care about, and constructs any necessary
associated objects, leaving you to specify only the attributes you *do* care
about in your tests. For example:

    describe Comment do
      it "should not include spam in the without_spam scope" do
        # This will make a Comment, a Post, and a User (the author of the
        # Post), generate values for all their attributes, and save them:
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

Check out the
[documentation](http://wiki.github.com/notahat/machinist/getting-started) for
more info.


## Contributors

Machinist is maintained by Pete Yandell ([pete@notahat.com](mailto:pete@notahat.com), [@notahat](http://twitter.com/notahat))

Other contributors include:

[Marcos Arias](http://github.com/yizzreel),
[Jack Dempsey](http://github.com/jackdempsey),
[Jeremy Durham](http://github.com/jeremydurham),
[Clinton Forbes](http://github.com/clinton),
[Perryn Fowler](http://github.com/perryn),
[Niels Ganser](http://github.com/Nielsomat),
[Jeremy Grant](http://github.com/jeremygrant),
[Jon Guymon](http://github.com/gnarg),
[James Healy](http://github.com/yob),
[Ben Hoskings](http://github.com/benhoskings),
[Evan David Light](http://github.com/elight),
[Chris Lloyd](http://github.com/chrislloyd),
[Adam Meehan](http://github.com/adzap),
[Kyle Neath](http://github.com/kneath),
[Lawrence Pit](http://github.com/lawrencepit),
[Xavier Shay](http://github.com/xaviershay),
[T.J. Sheehy](http://github.com/tjsheehy),
[Roland Swingler](http://github.com/knaveofdiamonds),
[Gareth Townsend](http://github.com/quamen),
[Matt Wastrodowski](http://github.com/towski),
[Ian White](http://github.com/ianwhite)

Thanks to Thoughtbot's [Factory
Girl](http://github.com/thoughtbot/factory_girl/tree/master). Machinist was
written because I loved the idea behind Factory Girl, but I thought the
philosophy wasn't quite right, and I hated the syntax.
  
