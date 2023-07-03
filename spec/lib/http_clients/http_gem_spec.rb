# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HttpClients::HttpGem do
  describe '#request' do
    subject(:make_request) { described_class.new.request(method, url, headers, params) }

    let(:method) { :get }
    let(:url) { 'https://example.com' }
    let(:headers) { { 'Content-Type' => 'application/json' } }
    let(:params) { { page: 1 } }
    let(:response) { 'response' }

    context 'when method is :get' do
      let(:http_double) { instance_double(HTTP::Client) }

      before do
        allow(HTTP).to receive(:headers).and_return(http_double)
        allow(http_double).to receive(:get).and_return(response)
      end

      it 'sends a GET request with the provided arguments' do
        make_request

        expect(http_double).to have_received(:get).with(url, params:)
      end

      it 'returns the response' do
        expect(make_request).to eq(response)
      end
    end

    context 'when method is unsupported' do
      let(:method) { :post }

      it 'raises an ArgumentError' do
        expect { make_request }
          .to raise_error(ArgumentError, "Unsupported HTTP method: #{method}")
      end
    end
  end
end
