# frozen_string_literal: true

module Forecast
  # Wrapper for interactions with cache system
  module Cache
    module_function

    # Key for storing the cache
    BASE_KEY = 'forecast:cache_results'
    SEPARATOR = ':'
    # Cache time to live
    TTL = 30.minutes

    def read(zip_code)
      return unless zip_code

      Rails.cache.read(key(zip_code))
    end

    def write(zip_code, data)
      return unless zip_code && data

      Rails.cache.write(key(zip_code), data, expires_in: TTL)
    end

    # The method is used to fetch a key for writing a cache
    def self.key(zip_code)
      [BASE_KEY, zip_code].join(SEPARATOR)
    end
  end
end
