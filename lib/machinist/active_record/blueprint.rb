module Machinist::ActiveRecord
  class Blueprint < Machinist::Blueprint

    def make!(attributes = {})
      object = make(attributes)
      object.save!
      object.reload
    end

    # Execute a block on a separate database connection, so that any database
    # operations happen outside any open transactions.
    def outside_transaction
      # ActiveRecord manages connections per-thread, so the only way to
      # convince it to open another connection is to start another thread. It's
      # not the nicest, but it works.
      thread = Thread.new do
        begin
          yield
        ensure
          ::ActiveRecord::Base.connection_pool.checkin(::ActiveRecord::Base.connection)
        end
      end
      thread.value
    end

    def serialize(object)  # FIXME: Naming
      object.id
    end
    
    def instantiate(id)  # FIXME: Naming
      @klass.find(id)
    end

    def lathe_class #:nodoc:
      Machinist::ActiveRecord::Lathe
    end

  end
end
