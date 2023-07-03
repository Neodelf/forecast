# frozen_string_literal: true

module Forecast
  module OutputFormatters
    # The class is responsible for transforming incoming data into HTML format for rendering.
    class Html < ::Forecast::OutputFormatters::Base
      UNAVAILABLE_TEMP_F = 'unavailable'

      def forecast(data)
        temp_f = data.fetch(:temp_f, nil) || UNAVAILABLE_TEMP_F
        I18n.t('web.html_formatter.forecast_html', temp_f:)
      end

      def processing
        I18n.t('web.html_formatter.processing_html')
      end

      def error(data)
        I18n.t('web.html_formatter.error_html', data:)
      end
    end
  end
end
