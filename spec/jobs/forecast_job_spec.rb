# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForecastJob do
  subject(:job) { described_class }

  let(:formatter) { Forecast::OutputFormatters::Html.new }
  let(:zip_code) { '12345' }
  let(:user_session_id) { 'abc123' }
  let(:fetcher) { instance_double(Forecast::Fetcher) }
  let(:success) { true }
  let(:data) { { temp_f: 72 } }
  let(:result) { Forecast::Fetcher::Result.new(success, data) }

  before do
    allow(Forecast::Fetcher).to receive(:new).with(zip_code).and_return(fetcher)
    allow(fetcher).to receive(:call).and_return(result)
  end

  describe '#perform' do
    it 'calls the Fetcher to retrieve the forecast data' do
      job.perform_now(zip_code, user_session_id, formatter)

      expect(fetcher).to have_received(:call)
    end
  end

  describe 'callbacks' do
    let(:job_notifications) { instance_double(ForecastJobNotifications) }

    before do
      allow(ForecastJobNotifications).to receive(:new).with(user_session_id, formatter).and_return(job_notifications)
      allow(job_notifications).to receive(:forecast)
      allow(job_notifications).to receive(:error)
    end

    it 'calls a forecast notificator' do
      job.perform_now(zip_code, user_session_id, formatter)

      expect(job_notifications).to have_received(:forecast)
    end

    context 'when there is an error' do
      let(:success) { false }

      it 'calls an error notificator' do
        job.perform_now(zip_code, user_session_id, formatter)

        expect(job_notifications).to have_received(:error)
      end
    end
  end
end
