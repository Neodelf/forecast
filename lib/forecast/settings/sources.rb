# frozen_string_literal: true

module Forecast
  module Settings
    # Base class for having DSL. Used to store sources configurations
    class Sources
      class << self
        attr_reader :sources

        def config(&)
          @sources = []
          instance_exec(self, &)
        end

        def add(&)
          source = Source.new
          source.instance_exec(&)
          @sources << source
        end
      end

      class Source
        attr_accessor :config

        PARAMS = %i[url method headers params requests adapter].freeze

        def initialize
          @config = PARAMS.index_with { |_x| nil }
        end

        PARAMS.each do |method|
          define_method method do |value|
            @config[method] = value
          end
        end
      end
    end
  end
end
