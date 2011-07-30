require 'datamapper'
require 'machinist/data_mapper'

DataMapper.setup(:default, 'sqlite::memory:')

module DataMapperModels
  class User
    include DataMapper::Resource
    property :username, String, :key => true
    validates_presence_of :username
    validates_uniqueness_of :username
  end

  class Post < ActiveRecord::Base
    include DataMapper::Resource
    property :id, Serial
    property :title, String, :required => false
    property :body, Text, :required => false

    has n, :comments
    belongs_to :author, :model => User, :required => false
    has n, :tags, :through => Resource
  end

  class Comment < ActiveRecord::Base
    include DataMapper::Resource
    property :id, Serial
    property :body, Text, :required => false
    belongs_to :post, :required => false
  end

  class Tag < ActiveRecord::Base
    include DataMapper::Resource
    property :id, Serial
    property :name, Text, :required => false
    has n, :posts, :through => Resource, :required => false
  end


  module DataMapperEnvironment

    def empty_database!
      [User, Post, Comment].each do |klass|
        klass.all.destroy
        klass.clear_blueprints!
      end
    end

  end
end

DataMapper.auto_migrate!
