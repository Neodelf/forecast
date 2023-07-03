# frozen_string_literal: true

class ForecastJob < ApplicationJob
  queue_as :forecast

  before_enqueue do |_job|
    @notificator.processing
  end

  after_perform do |_job|
    # As well as the job is finished, notify user with information
    if @result.success
      @notificator.forecast(@result.data)
    else
      @notificator.error(@result.data)
    end
  end

  def perform(zip_code, user_session_id, formatter = Forecast::OutputFormatters::Html.new)
    @formatter = formatter
    @user_session_id = user_session_id
    @notificator = ::ForecastJobNotifications.new(user_session_id, formatter)
    @result = Forecast::Fetcher.new(zip_code).call
  end
end
