# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast::Fetcher do
  subject(:fetcher) { described_class.new(zip_code).call }

  before do
    allow(Forecast::Data).to receive(:new).and_return(double('data', fetch: response))
  end

  let(:zip_code) { '12345' }
  let(:response) { { 'TempF' => '72.0' } }

  describe '#call' do
    it 'returns correct result' do
      expect(fetcher).to eq(Forecast::Fetcher::Result.new(true, { temp_f: '72.0' }))
    end

    context 'when the data is wrong' do
      let(:zip_code) { nil }

      it 'returns correct result' do
        expect(fetcher).to eq(Forecast::Fetcher::Result.new(false, "Zip code is not a number, Zip code can't be blank"))
      end
    end
  end
end
