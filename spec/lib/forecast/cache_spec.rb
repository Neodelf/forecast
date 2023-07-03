# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast::Cache do
  let(:zip_code) { '12345' }
  let(:cache_key) { "forecast:cache_results:#{zip_code}" }
  let(:data) { 'data' }

  describe '#read' do
    subject(:read) { described_class.read(zip_code) }

    before do
      allow(Rails.cache).to receive(:read).with(cache_key).and_return(data)
    end

    context 'when zip_code is valid' do
      it 'returns nil' do
        expect(read).to eq(data)
      end

      it 'uses a Rails cache system' do
        read
        expect(Rails.cache).to have_received(:read).with(cache_key)
      end
    end

    context 'when zip_code is invalid' do
      let(:zip_code) { nil }

      it 'returns nil' do
        expect(read).to be_nil
      end
    end
  end

  describe '#write' do
    subject(:write) { described_class.write(zip_code, data) }

    before do
      allow(Rails.cache).to receive(:write).with(cache_key, data, expires_in: 30.minutes)
    end

    context 'when zip_code is valid' do
      it 'returns nil' do
        expect(write).to be_nil
      end

      it 'writes to a Rails cache system' do
        write
        expect(Rails.cache).to have_received(:write).with(cache_key, data, expires_in: 30.minutes)
      end
    end

    context 'when zip_code is invalid' do
      let(:zip_code) { nil }

      it 'returns nil' do
        expect(write).to be_nil
      end

      context 'when data is invalid' do
        let(:data) { nil }

        it 'returns nil' do
          expect(write).to be_nil
        end
      end
    end
  end
end
