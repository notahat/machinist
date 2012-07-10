require 'sequel'
require 'sequel/extensions/migration'
require 'machinist/sequel'

DB = Sequel.mysql(:database => 'machinist')

Sequel.migration do
  change do
    create_table! :users do
      primary_key :id
      String :username
    end

    create_table! :posts do
      primary_key :id
      String :title
      Integer :author_id
      String :body, :text => true
    end

    create_table! :comments do
      primary_key :id
      Integer :post_id
      String :body, :text => true
    end

    create_table! :tags do
      primary_key :id
      String :name
    end

    create_table! :posts_tags do
      Integer :post_id
      Integer :tag_id
    end
  end
end


module SequelEnvironment

  class User < Sequel::Model
    plugin :validation_helpers

    def validate
      super
      validates_presence :username
      validates_unique :username
    end
  end

  class Post < Sequel::Model
    one_to_many :comments
    many_to_one :author, :class_name => "SequelEnvironment::User"
    many_to_many :tags
  end

  class Comment < Sequel::Model
    many_to_one :post
  end

  class Tag < Sequel::Model
    many_to_many :posts
  end

  def empty_database!
    [User, Post, Comment].each do |klass|
      klass.delete
      klass.clear_blueprints!
    end
  end

end
