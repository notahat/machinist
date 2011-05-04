require 'dm-core'
require 'dm-migrations'
require 'dm-validations'
require 'dm-transactions'
require 'machinist/datamapper'

DataMapper.setup(:default, 'sqlite::memory:')

module DataMapperEnvironment

  class User
    include DataMapper::Resource

    property :id, Serial
    property :username, String, :required => true, :unique => true
  end

  class Post
    include DataMapper::Resource

    property :id, Serial
    property :author_id, Integer
    property :body, Text

    belongs_to :author, 'User'
    has n, :comments
    has n, :tags, :through => Resource
  end

  class Comment
    include DataMapper::Resource

    property :id, Serial
    property :body, Text

    belongs_to :post
  end

  class Tag
    include DataMapper::Resource

    property :id, Serial
    property :name, String

    has n, :posts, :through => Resource
  end

  def self.empty_database!
    DataMapper.auto_migrate!
    [User, Post, Comment].each do |klass|
      klass.clear_blueprints!
    end
  end

end
