# Machinist 2

This is an early alpha version of Machinist 2.


## What's New

- Caching, FTW!!!!
- Collections -- make lots of objects in one hit (coming soon)


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
