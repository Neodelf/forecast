# frozen_string_literal: true

class ForecastJobNotifications
  CABLE_BASE_NAME = 'forecast_job_notifications'
  SEPARATOR = ':'

  def initialize(user_session_id, formatter = Forecast::OutputFormatters::Html.new)
    @cable_name = [CABLE_BASE_NAME, user_session_id].join(SEPARATOR)
    @formatter = formatter
  end

  def processing
    # Notify that the process is started
    ActionCable.server.broadcast(cable_name,
                                 { message: formatter.processing, cached: false })
  end

  def forecast(data, cached = false)
    # Notify that the process is finished
    message = formatter.forecast(data)
    ActionCable.server.broadcast(cable_name, { message:, cached: })
  end

  def error(data)
    message = formatter.error(data)
    ActionCable.server.broadcast(cable_name, { message:, cached: false })
  end

  private

  attr_reader :cable_name, :formatter
end
