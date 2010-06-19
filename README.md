# Machinist 2

*Fixtures aren't fun. Machinist is.*

## What's New?

Now you get all the convenience of Machinist, with the performance of fixtures.

When you create an object, Machinist 2 keeps the object around in the database.
If, in a later test, you request an identical object, Machinist will give you
the cached copy.

## Introduction

Nobody loves fixtures. How do you avoid them?

It would be nice to just make model objects as you need them, but your models
probably have lots of required attributes, which means you end up writing
something like:

    user = User.create!(:username => "fred", :email => "fred@example.com", :password => "secret", :password_confirmation => "secret")

when your test only cares about one or two attributes.

With Machinist, you just write:

    user = User.make!(:password => "secret")

Machinist knows how to generate values for the attributes you don't specify in
your test. How? You define a blueprint for User class in `spec/blueprints.rb`:

    User.bluerint do
      username              { "user#{serial_number}" }  # Each user gets a unique serial number.
      email                 { "#{attributes.username}@example.com" }
      password              { "secret" }
      password_confirmation { attributes.password }
    end


## Docs

### Caching

Whenever you generate an object using `make!`, Machinist keeps it in the
database. If you request an identicaly object in another test, you'll get the
cached object back.

- Serial Numbers
- Accessing Other Attributes
- Associations
- make vs make!


## Example

In `app/models/user.rb` you define your model:

    class User < ActiveRecord::Base
      validates_presence_of :username, :email, :password
      validates_uniqueness_of :username
      validates_confirmation_of :password
    end

In `spec/blueprints.rb` you define a blueprint for the user:

    User.bluerint do
      username              { "user#{sn}" }
      email                 { "#{attr.username}@example.com" }
      password              { "secret" }
      password_confirmation { attr.password }
    end

In `spec/models/user_spec.rb` you use Machinist to make a user for you.
Machinist uses the blueprint to generate any attributes you don't explicitly
provide.

    describe User do
      it "should match the user's password" do
        user = User.make!(:password => "special-password")
        user.password_matches?("special-password").should be_true
        user.password_matches?("wrong-password").should be_false
      end
    end


## What's New

- Caching, FTW!!!!
- Collections -- make lots of objects in one hit (experimental)


## What's Different

Machnist 2 is not a drop-in replacement for Machinist 1. Implementing
caching has required substantial changes to the API.

- No more Sham
- Use `make!` if you want a saved object, or `make` if you don't
- Use `object` in the blueprint to access attributes that have already been
  assigned on the object being constructed


## What's Not There Yet

- No easy upgrade path from Machinist 1
- No `make` method on associations
- No support for ORMs other than ActiveRecord
- Blueprints don't follow class inheritance
- No `plan` method


## What's Broken

- The master blueprint for a class has to be defined before any named
  blueprints, or inheritance won't work


## Stuff I'm Still Thinking About

- Easy support for different construction strategies, e.g. generating all the
  attributes and passing them to new as a hash
