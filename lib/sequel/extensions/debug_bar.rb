# frozen-string-literal: true

require "sequel"

module DebugBar
  module Sequel

    if ::Sequel::VERSION_NUMBER >= 50240
      def skip_logging?
        false
      end
    end

    def self.extended(base)
      if ::Sequel::VERSION_NUMBER < 50240
        return if base.loggers.any?

        require "logger"
        base.loggers = [Logger.new("/dev/null")]
      end

      # ::Sequel::Model.plugin :after_initialize
    end

    # def self.configure(model, opts = {})
    #   model.include InstanceMethods
    # end

    def log_duration(duration, message)
      Roda::DebugBar::Current.increment_accrued_database_time(duration)
      Roda::DebugBar::Current.increment_database_query_count
      Roda::DebugBar::Current.add_database_query(message, duration.round(6))

      super
    end
  end

  ::Sequel::Database.register_extension :debug_bar, DebugBar::Sequel
end
