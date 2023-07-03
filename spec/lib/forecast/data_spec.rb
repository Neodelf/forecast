# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast::Data do
  before do
    Forecast::Settings::Sources.config do
      add do
        url 'https://example.com/weather'
        method :get
        headers lambda {
          {
            'X-RapidAPI-Key': Rails.application.credentials.rapid_api_key,
            'X-RapidAPI-Host': 'example.com'
          }
        }
        params lambda { |value|
          { zip: value }
        }
        adapter Forecast::Sources::Adapters::UsWeatherByZipCode.new
        requests 1000
      end
    end
  end

  describe '#request' do
    subject(:fetch) { described_class.new(config, zip_code).fetch }

    let(:config) { Forecast::Settings::Sources.sources[0].config }
    let(:http_client) { instance_double(HttpClient) }
    let(:response_body) do
      '{
        "TempF": "72.0"
      }'
    end
    let(:response) { JSON.parse(response_body) }
    let(:zip_code) { 123_456 }
    let(:rapid_api_key) { '123' }
    let(:rate_limit_exceeded) { false }
    let(:limiter) { instance_double(RateLimiter) }

    before do
      allow(HttpClient).to receive(:new) { http_client }
      allow(http_client).to receive(:request) { response }
      allow(JSON).to receive(:parse).and_return({
                                                  'TempF' => '72.0'
                                                })
      allow(Rails.application.credentials).to receive(:rapid_api_key).and_return(rapid_api_key)

      allow(RateLimiter).to receive(:new).and_return(limiter)
      allow(limiter).to receive(:rate_limit_exceeded?).and_return(rate_limit_exceeded)
      # allow(limiter).to receive(:mark_request)
      allow(limiter).to receive(:run).and_return(response)
      allow(Forecast::Cache).to receive(:write).with(zip_code, response)
    end

    it 'writes a response to cache' do
      fetch

      expect(Forecast::Cache).to have_received(:write).with(zip_code, response)
    end

    it 'parses the response body as JSON' do
      fetch

      expect(JSON).to have_received(:parse).with(response_body)
    end

    it 'returns the parsed JSON response' do
      expect(fetch).to eq({
                            'TempF' => '72.0'
                          })
    end

    context 'when rate limit is exceeded' do
      let(:rate_limit_exceeded) { true }

      it 'skips the source' do
        fetch

        expect(http_client).not_to have_received(:request)
      end
    end
  end
end
