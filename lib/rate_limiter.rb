# frozen_string_literal: true

# Limits number of requests to the specific source
class RateLimiter
  attr_reader :source

  def initialize(params, redis = Redis.current_connection)
    @total_requests = params[:total_requests]
    @config_key = params[:config_key]
    @redis = redis
  end

  def run
    return unless block_given?
    return if rate_limit_exceeded?

    response = yield
    inc_requests
    response
  end

  def rate_limit_exceeded?
    remaining_requests <= 0
  end

  def remaining_requests
    total_requests - used_requests
  end

  def inc_requests
    redis.incr(key)
  end

  private

  attr_reader :redis, :total_requests, :config_key

  def key
    "rate_limiter:#{config_key}"
  end

  def used_requests
    redis.get(key).to_i
  end
end
