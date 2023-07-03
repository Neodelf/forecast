# frozen_string_literal: true

module Forecast
  module Sources
    module Adapters
      # Base class for future adapters
      class Base
        def parse(data)
          {
            temp_f: temp_f(data)
          }
        end

        private

        def temp_f
          raise NotImplementedError
        end
      end
    end
  end
end
