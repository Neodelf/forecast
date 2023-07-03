# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast::OutputFormatters::Html do
  subject(:formatter) { described_class.new }

  describe '#forecast' do
    subject { formatter.forecast(data) }

    let(:data) { { temp_f: 75.5 } }

    it 'renders the HTML message with the temperature' do
      expect(subject).to eq('<p><strong>TempF: </strong>75.5</p>')
    end

    context 'when data doesn\'t have information' do
      let(:data) { { temp_f: nil } }

      it 'renders the default HTML message without a temperature' do
        expect(subject).to eq('<p><strong>TempF: </strong>unavailable</p>')
      end
    end

    context 'when data doesn\'t have a key' do
      let(:data) { {} }

      it 'renders the default HTML message without a temperature' do
        expect(subject).to eq('<p><strong>TempF: </strong>unavailable</p>')
      end
    end
  end

  describe '#processing' do
    subject { formatter.processing }

    it 'renders the HTML message with the temperature' do
      expect(subject).to eq('<p><strong>Processing...</strong></p>')
    end
  end
end
