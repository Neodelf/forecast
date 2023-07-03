# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpClient do
  let(:library) { instance_double(HttpClients::HttpGem) }

  describe '#get' do
    let(:url) { 'https://example.com' }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:params) { { id: 1 } }
    let(:method) { :get }

    before do
      allow(library).to receive(:request)
    end

    it 'forwards the GET request to the request strategy' do
      client = described_class.new(library)
      client.request(method, url, headers, params)

      expect(library).to have_received(:request).with(:get, url, headers, params)
    end
  end

  describe '#library=' do
    subject(:client) { described_class.new }

    it 'sets the request strategy' do
      client.library = library

      expect(client.instance_variable_get(:@library)).to eq(library)
    end
  end
end
