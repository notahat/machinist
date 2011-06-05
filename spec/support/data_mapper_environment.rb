require 'dm-core'
require 'dm-validations'
require 'machinist/data_mapper'

DataMapper.setup(:default, :adapter => :in_memory)

module DataMapperEnvironment
  class User
    include DataMapper::Resource

    property :id,       Serial
    property :username, String

    validates_presence_of :username
    validates_uniqueness_of :username
  end

  class Post
    include DataMapper::Resource

    property :id,       Serial
    property :title,    String
    property :body,     Text

    belongs_to :author, 'User', :required => false
    has n, :comments
    has n, :tags, :through => Resource
  end

  class Comment
    include DataMapper::Resource

    property :id,       Serial
    property :body,     Text

    belongs_to :post, :required => false
  end

  class Tag
    include DataMapper::Resource

    property :id,       Serial
    property :name,     String

    has n, :posts, :through => Resource
  end

  def purge_models!
    User.destroy
    Post.destroy
    Comment.destroy
    Tag.destroy
  end
end

DataMapper.finalize
