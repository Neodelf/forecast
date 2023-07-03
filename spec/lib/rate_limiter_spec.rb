# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RateLimiter do
  subject { described_class.new(params, redis) }

  let(:params) do
    {
      total_requests: requests,
      config_key: 'example_source'
    }
  end
  let(:redis) { MockRedis.new }
  let(:requests) { 5 }

  describe '#run' do
    it 'returns block\'s result' do
      expect(subject.run { 1 }).to eq(1)
    end

    it 'decreases remaining requests number' do
      expect { subject.run { 1 } }.to change(subject, :remaining_requests).by(-1)
    end
  end

  describe '#rate_limit_exceeded?' do
    context 'when remaining requests is greater than 0' do
      it 'returns false' do
        expect(subject.rate_limit_exceeded?).to be false
      end
    end

    context 'when remaining requests is 0' do
      let(:requests) { 0 }

      it 'returns true' do
        expect(subject.rate_limit_exceeded?).to be true
      end
    end

    context 'when remaining requests is negative' do
      let(:requests) { -5 }

      it 'returns true' do
        expect(subject.rate_limit_exceeded?).to be true
      end
    end
  end

  describe '#remaining_requests' do
    it 'returns the remaining requests' do
      expect(subject.remaining_requests).to eq(5)
    end
  end
end
