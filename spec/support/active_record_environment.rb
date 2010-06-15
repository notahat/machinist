require 'active_record'

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
end

class User < ActiveRecord::Base
  validates_presence_of :username
  validates_uniqueness_of :username
end

class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :author, :class_name => "User"
end

class Comment < ActiveRecord::Base
  belongs_to :post
end

module ActiveRecordEnvironment

  def clear_active_record_blueprints!
    [User, Post, Comment].each(&:clear_blueprints!)
  end

end
