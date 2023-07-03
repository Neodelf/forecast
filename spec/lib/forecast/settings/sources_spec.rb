# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast::Settings::Sources do
  subject(:sources) { described_class.sources }

  before do
    described_class.config {}
  end

  describe '.add' do
    context 'when there are not one source' do
      before do
        described_class.config do
          add do
            url 'http://example.com/weather-api'
            requests 1000
          end

          add do
            url 'http://example.com/weather-api-2'
            requests 100
          end
        end
      end

      it 'configures the first source correctly' do
        expect(sources.first.config).to eq({ adapter: nil, headers: nil, method: nil, params: nil,
                                             requests: 1000, url: 'http://example.com/weather-api' })
      end

      it 'configures the second source correctly' do
        expect(sources.second.config).to eq({ adapter: nil, headers: nil, method: nil, params: nil,
                                              requests: 100, url: 'http://example.com/weather-api-2' })
      end
    end
  end
end
