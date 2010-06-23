module Machinist::Strategies

  # If you have a blueprint:
  #
  #     Post.blueprint(:strategy => :assign_attributes) do
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

    def prepare #:nodoc:
      @object = @klass.new
    end

    # Call this within the blueprint to access to the object under construction.
    attr_reader :object

    def assign_attribute(key, value) #:nodoc:
      super
      @object.send("#{key}=", value)
    end

    alias_method :finalised_object, :object

  end

  register :assign_attributes, AssignAttributes

end
