# frozen-string-literal: true

require "sequel"

module Sequel
  module Plugins
    module DebugBar

      module ClassMethods

        def call(_)
          v = super
          v.after_initialize
          v
        end

      end

      module InstanceMethods

        def initialize(h={})
          super
          after_initialize
        end

        def after_initialize
          Roda::DebugBar::Current.add_model(self.class, self.values)
          puts "created #{self.inspect}"
        end
      end

      def self.extended(base)
        # ::Sequel::Model.plugin :after_initialize
      end

      def self.apply(model, opts = {})
        model.include InstanceMethods
        model.include ClassMethods
      end

      # def self.configure(model, opts = {})
      #   model.include InstanceMethods
      #   model.include ClassMethods
      # end

    end
  end

  Model.plugin :debug_bar, Sequel::Plugins::DebugBar
end
