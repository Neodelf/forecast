# frozen_string_literal: true

module Forecast
  module Sources
    module Adapters
      # Adapter for Weatherapi source for fetching data in properly format
      class Weatherapi < ::Forecast::Sources::Adapters::Base
        CURRENT_KEY = 'current'
        TEMP_F_KEY = 'temp_f'

        private

        def temp_f(data)
          data&.fetch(CURRENT_KEY, nil)&.fetch(TEMP_F_KEY, nil)
        end
      end
    end
  end
end
