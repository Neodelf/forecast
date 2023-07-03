# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForecastJobNotifications do
  let(:instance) { described_class.new(user_session_id, formatter) }
  let(:user_session_id) { 'user_session_id' }
  let(:formatter) { Forecast::OutputFormatters::Html.new }
  let(:data) { { temp_f: 72.0 } }
  let(:cable_name) { 'forecast_job_notifications:user_session_id' }
  let(:action_cable) { ActionCable.server }

  before do
    allow(action_cable).to receive(:broadcast)
  end

  describe '#forecast' do
    subject { instance.forecast(data, cache) }

    let(:cache) { false }
    let(:expected_message) { '<p><strong>TempF: </strong>72.0</p>' }

    it 'calls broadcaster' do
      subject

      expect(action_cable).to have_received(:broadcast)
        .with(cable_name, { message: expected_message, cached: false })
    end

    context 'when cache is true' do
      let(:cache) { true }

      it 'calls broadcaster' do
        subject

        expect(action_cable).to have_received(:broadcast)
          .with(cable_name, { message: expected_message, cached: true })
      end
    end
  end

  describe '#error' do
    subject { instance.error(data) }

    let(:data) { 'error message' }
    let(:expected_message) { '<p><strong>Errors: </strong>error message</p>' }

    it 'calls broadcaster' do
      subject

      expect(action_cable).to have_received(:broadcast)
        .with(cable_name, { message: expected_message, cached: false })
    end
  end

  describe '#processing' do
    subject { instance.processing }

    let(:expected_message) { '<p><strong>Processing...</strong></p>' }

    it 'calls broadcaster' do
      subject

      expect(action_cable).to have_received(:broadcast)
        .with(cable_name, { message: expected_message, cached: false })
    end
  end
end
