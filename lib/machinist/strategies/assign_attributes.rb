module Machinist::Strategies

  # If you have a blueprint:
  #
  #     Post.blueprint do
  #       title { "A Post" }
  #       body  { "Lorem ipsum..." }
  #     end
  #
  # this strategy is the equivalent of:
  #
  #     post = Post.new
  #     post.title = "A Post"
  #     post.body  = "Lorem ipsum..."
  #
  module AssignAttributes

    def prepare
      @object = @klass.new
    end

    # Give the blueprint access to the object under construction.
    attr_reader :object

    def assign_attribute(key, value)
      super
      @object.send("#{key}=", value)
    end

    alias_method :finalised_object, :object

  end

  register :assign_attributes, AssignAttributes

end
