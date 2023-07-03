# frozen_string_literal: true

module Forecast
  module OutputFormatters
    # Base class for future foermatters
    class Base
      def forecast
        raise NotImplementedError
      end

      def processing
        raise NotImplementedError
      end
    end
  end
end
