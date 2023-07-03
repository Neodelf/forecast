# frozen_string_literal: true

require 'redis'

class Redis
  class << self
    def current_connection
      @current_connection ||= ::Redis.new(url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1'))
    end
  end
end
