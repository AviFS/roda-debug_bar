class Roda
  module DebugBar
    module Current
      extend self

      # Increment the accrued database time
      # @param value [Numeric]
      #   the value to increment
      # @return [Numeric]
      #   the updated value
      def increment_accrued_database_time(value)
        Thread.current[:accrued_database_time] ||= 0
        Thread.current[:accrued_database_time] += value
      end

      # The accrued database time
      # @return [Numeric]
      def accrued_database_time
        Thread.current[:accrued_database_time]
      end

      # Set accrued database time
      # @param value [Numeric]
      #   the value to set
      # @return [Numeric]
      #   the new value
      def accrued_database_time=(value)
        Thread.current[:accrued_database_time] = value
      end

      def increment_database_query_count(value = 1)
        Thread.current[:database_query_count] ||= 0
        Thread.current[:database_query_count] += value
      end

      def database_query_count
        Thread.current[:database_query_count]
      end

      def database_query_count=(value)
        Thread.current[:database_query_count] = value
      end

      def add_database_query(message)
        Thread.current[:database_queries] ||= []
        Thread.current[:database_queries] << message
      end

      def database_queries
        Thread.current[:database_queries]
      end

      def database_queries=(value)
        Thread.current[:database_queries] = value
      end

      def add_model(model, values)
        Thread.current[:models] ||= {}
        Thread.current[:models][model.to_s] ||= []
        Thread.current[:models][model.to_s] << values
        # Thread.current[:models] << {name: model, values: values}
      end

      def models
        Thread.current[:models]
      end

      def models=(value)
        Thread.current[:models] = value
      end

      def add_view(view)
        Thread.current[:view] ||= []
        Thread.current[:view] << view
      end

      def views
        Thread.current[:view]
      end

      def views=(value)
        Thread.current[:view] = value
      end


      # Reset the counters
      def reset
        self.accrued_database_time = nil
        self.database_query_count = nil
        self.database_queries = nil
        self.models = nil
        self.views = nil
        true
      end
    end
  end
end
