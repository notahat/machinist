require 'active_record'
require 'machinist/active_record'

ActiveRecord::Base.establish_connection(
  :adapter  => "mysql",
  :database => "machinist",
  :username => "root",
  :password => ""
)

ActiveRecord::Schema.define(:version => 0) do
  create_table :users, :force => true do |t|
    t.column :username, :string
  end

  create_table :posts, :force => true do |t|
    t.column :title, :string
    t.column :author_id, :integer
    t.column :body, :text
  end

  create_table :comments, :force => true do |t|
    t.column :post_id, :integer
    t.column :body, :text
  end

  create_table :tags, :force => true do |t|
    t.column :name, :string
  end

  create_table :posts_tags, :id => false, :force => true do |t|
    t.column :post_id, :integer
    t.column :tag_id, :integer
  end
end

class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username
end

class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author, :class_name => "User"
  has_and_belongs_to_many :tags
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
end

module ActiveRecordEnvironment

  def empty_database!
    [User, Post, Comment].each do |klass|
      klass.delete_all
      klass.clear_blueprints!
    end
  end

end
