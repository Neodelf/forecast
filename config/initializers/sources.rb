# frozen_string_literal: true

require 'forecast/settings/sources'
require 'forecast/sources/adapters/base'
require 'forecast/sources/adapters/us_weather_by_zip_code'
require 'forecast/sources/adapters/weatherapi'

Forecast::Settings::Sources.config do
  add do
    url 'https://us-weather-by-zip-code.p.rapidapi.com/getweatherzipcode'
    method :get
    headers lambda {
      {
        'X-RapidAPI-Key': Rails.application.credentials.rapid_api_key,
        'X-RapidAPI-Host': 'us-weather-by-zip-code.p.rapidapi.com'
      }
    }
    params lambda { |value|
      { zip: value }
    }
    adapter Forecast::Sources::Adapters::UsWeatherByZipCode.new
    requests 0
  end

  add do
    url 'https://api.weatherapi.com/v1/current.json'
    method :get
    headers -> {}
    params lambda { |value|
      { key: Rails.application.credentials.weatherapi_api_key, q: value }
    }
    adapter Forecast::Sources::Adapters::Weatherapi.new
    requests 100
  end
end
