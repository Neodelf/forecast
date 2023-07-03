# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::ForecastsController do
  let(:user_id) { 'user_id' }

  describe '#index' do
    before do
      allow(SecureRandom).to receive(:hex).with(20).and_return(user_id)
      get :index
    end

    it 'returns 200 OK' do
      expect(response).to have_http_status(:ok)
    end

    it 'sets an identificator' do
      expect(response.cookies['user_id']).to eq('user_id')
    end
  end

  describe '#create' do
    subject(:post_request) { post :create, params: { zip_code: } }

    let(:zip_code) { '123123' }
    let(:cache_result) { { temp_f: 72.0 } }
    let(:notificator) { instance_double(ForecastJobNotifications, forecast: true) }

    before do
      cookies['user_id'] = user_id
      allow(Forecast::Cache).to receive(:read).and_return(cache_result)
      allow(ForecastJobNotifications).to receive(:new).with(user_id).and_return(notificator)
      allow(ForecastJob).to receive(:perform_now).with(zip_code, user_id)

      post_request
    end

    it 'reads cache' do
      expect(Forecast::Cache).to have_received(:read)
    end

    it 'doesn\'t run a worker' do
      expect(ForecastJob).not_to have_received(:perform_now)
    end

    it 'notifies the user' do
      expect(notificator).to have_received(:forecast)
    end

    context 'when cache is missed' do
      let(:cache_result) { nil }
      let(:formatter) { Forecast::OutputFormatters::Html.new }

      before do
        allow(Forecast::OutputFormatters::Html).to receive(:new).and_return(formatter)
        allow(ForecastJobNotifications).to receive(:new).with(user_id, formatter).and_return(notificator)

        post_request
      end

      it 'runs a worker' do
        expect(ForecastJob).to have_received(:perform_now).with(zip_code, user_id)
      end

      it 'doesn\'t notify a user from the controller' do
        expect(notificator).not_to have_received(:forecast)
      end
    end
  end
end
