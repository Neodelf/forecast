# frozen_string_literal: true

class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from(
      [
        ForecastJobNotifications::CABLE_BASE_NAME,
        current_user.session
      ].join(ForecastJobNotifications::SEPARATOR)
    )
  end

  def unsubscribed; end
end
