# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpClient do
  subject(:http_client) { described_class.new(request_strategy) }

  let(:request_strategy) { instance_double(HttpClients::HttpGem) }
  let(:method) { 'GET' }
  let(:url) { 'https://example.com/api' }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:params) { { param1: 'value1', param2: 'value2' } }

  describe '#request' do
    before do
      allow(request_strategy).to receive(:request).with(method, url, headers, params)
    end

    it 'calls the request method on the request strategy' do
      http_client.request(method, url, headers, params)

      expect(request_strategy).to have_received(:request).with(method, url, headers, params)
    end
  end
end
