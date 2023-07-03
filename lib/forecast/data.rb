# frozen_string_literal: true

module Forecast
  # Sends request to a forecast source and uses HttpClient
  class Data
    include ActiveModel::Validations

    validates :zip_code, :config, presence: true

    def initialize(config, zip_code, client = HttpClient.new)
      @config = config
      @zip_code = zip_code
      @client = client
    end

    def fetch
      return unless valid?

      response = ::RateLimiter.new(limiter_params).run { make_request(config) }
      return unless response

      Forecast::Cache.write(zip_code, response)
      response
    end

    private

    attr_reader :zip_code, :client, :config

    def make_request(_source)
      JSON.parse(
        client.request(
          config[:method],
          config[:url],
          config[:headers].call,
          config[:params].call(zip_code)
        )
      )
    end

    def limiter_params
      {
        total_requests: config[:requests],
        config_key: config[:url]
      }
    end
  end
end
