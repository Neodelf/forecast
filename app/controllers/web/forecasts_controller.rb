# frozen_string_literal: true

module Web
  class ForecastsController < Web::ApplicationController
    def index
      # Identify user by sessing a user_id cookie
      cookies.permanent[:user_id] = SecureRandom.hex(20)
    end

    def create
      # Receive cache data or put message to the queue
      cached_data = Forecast::Cache.read(zip_code)
      if cached_data
        render_forecast(cached_data)
      else
        ForecastJob.perform_now(zip_code, user_id)
      end
    end

    private

    def zip_code
      params[:zip_code]
    end

    def user_id
      request.cookies['user_id']
    end

    def render_forecast(data)
      # Notify a user about weather forecast information
      ::ForecastJobNotifications.new(user_id).forecast(data, true)
    end
  end
end
