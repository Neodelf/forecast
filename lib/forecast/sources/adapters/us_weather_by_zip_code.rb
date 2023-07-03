# frozen_string_literal: true

module Forecast
  module Sources
    module Adapters
      # Adapter for UsWeatherByZipCode source for fetching data in properly format
      class UsWeatherByZipCode < Forecast::Sources::Adapters::Base
        TEMP_F_KEY = 'TempF'

        private

        def temp_f(data)
          data&.fetch(TEMP_F_KEY, nil)
        end
      end
    end
  end
end
