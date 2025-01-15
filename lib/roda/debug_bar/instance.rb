# frozen-string-literal: true
require "roda"

class Roda
  module DebugBar
    ##
    # Logger instance for this application
    class Instance

      # Application root
      attr_reader :root

      # Log entries generated during request
      attr_reader :log_entries

      # Logger instance
      attr_reader :logger

      # Route matches during request
      attr_reader :matches

      attr_reader :timer
      private :timer

      # Callable object to filter log entries
      attr_reader :filter



      ### added
      attr_accessor :debug_data

      # attr_reader :views
      ###


      def initialize(logger, env, instance_id, root, filter)
        @logger = logger
        @root = root
        @log_entries = []
        # @views = []
        @messages = []
        @matches = []
        @timer = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        @filter = filter || proc { false }
        if env["debug_bar_id"].nil?
          @primary = true
          env["debug_bar"] = instance_id
        else
          @primary = false
        end
      end

      # Add a matched route handler
      def add_match(caller)
        @matches << caller
      end

      # Add log entry for request
      # @param status [Integer]
      #   status code for the response
      # @param request [Roda::RodaRequest]
      #   request object
      # @param trace [Boolean]
      #   tracing was enabled
      def add(status, request, trace = false)
        if (last_matched_caller = matches.last)
          handler = format("%s:%d",
            Pathname(last_matched_caller.path).relative_path_from(root),
            last_matched_caller.lineno)
        end

        if handler.nil?
          handler = 'nilString'
        end

        meth =
          case status
          when 400..499
            :warn
          when 500..599
            :error
          else
            :info
          end

        data = {
          duration: (Process.clock_gettime(Process::CLOCK_MONOTONIC) - timer).round(4),
          status: status,
          verb: request.request_method,
          path: request.path,
          remaining_path: request.remaining_path,
          handler: handler,
          params: request.params
        }

        if (db = Roda::DebugBar::Current.accrued_database_time)
          data[:db] = db.round(6)
        else
          data[:db] = false
        end

        if (query_count = Roda::DebugBar::Current.database_query_count)
          data[:db_queries] = query_count
        end

        if (queries = Roda::DebugBar::Current.database_queries)
          data[:db_messages] = queries
        end

        if (models = Roda::DebugBar::Current.models)
          data[:models] = models
        end

        if (views = Roda::DebugBar::Current.views)
          data[:views] = views
        end

        if @messages
          data[:messages] = @messages
        end

        data[:request] = request

        # data[:request_inspect] = request.env

        # data[:views] = @views

        if trace
          p "matches: #{matches}"
          matches.each do |match|
            add_log_entry([meth, format("  %s (%s:%s)",
              File.readlines(match.path)[match.lineno - 1].strip.sub(" do", ""),
              Pathname(match.path).relative_path_from(root),
              match.lineno)])


            handler = File.readlines(match.path)[match.lineno - 1].strip.sub(" do", "")
            path = "#{Pathname(match.path).relative_path_from(root)}:#{match.lineno}"
            Roda::DebugBar::Current.add_route(handler, path)
          end
        end

        if (routes = Roda::DebugBar::Current.routes)
          data[:routes] = routes
        end

        return if filter.call(request.path)

        @debug_data = data
        add_log_entry([meth, "#{request.request_method} #{request.path}", data])
      end

      # This instance is the primary logger
      # @return [Boolean]
      def primary?
        @primary
      end

      # Drain the log entry queue, writing each to the logger at their respective level
      # @return [Boolean]
      def drain
        return unless primary?

        log_entries.each do |args|
          logger.public_send(*args)
        end

        true
      end

      # Reset the counters for this thread
      # @return [Boolean]
      def reset
        Roda::DebugBar::Current.reset
      end

      private

      # def add_view(view)
      #   raise "Error: @views is nil" if @views.nil?
      #   @views << view
      #   puts @views
      # end

      # built-in from roda-enhanced_logger
      def add_log_entry(record)
        @log_entries << record
      end

      public

      # logged to message tab
      def add_message(log_level, message)
        @messages << {type: log_level, message: message}
      end
    end
  end
end
