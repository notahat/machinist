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
  #     Post.new(:title => "A Post", :body => "Lorem ipsum...")
  #
  module PassAttributesToNew

    def finalised_object
      @klass.new(@assigned_attributes)
    end

  end

  register :pass_attributes_to_new, PassAttributesToNew

end

