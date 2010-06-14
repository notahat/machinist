require File.dirname(__FILE__) + '/spec_helper'
require 'machinist/active_record'

module ActiveRecordSpecs
  def self.setup_db
    ActiveRecord::Base.establish_connection(
      :adapter  => "mysql",
      :database => "machinist",
      :host     => "localhost",
      :username => "root",
      :password => ""
    )

    ActiveRecord::Schema.define(:version => 0) do
      create_table :posts, :force => true do |t|
        t.column :title, :string
        t.column :body, :text
      end
    end
  end

  class Post < ActiveRecord::Base
  end
end

describe Machinist::ActiveRecord do
  before(:all) do
    ActiveRecordSpecs.setup_db
  end

  before(:each) do
    ActiveRecordSpecs::Post.clear_blueprints!
  end

  it "should make and save an object" do
    ActiveRecordSpecs::Post.blueprint { }
    post = ActiveRecordSpecs::Post.make!
    post.should be_a(ActiveRecordSpecs::Post)
    post.should_not be_new_record
  end

  
end
