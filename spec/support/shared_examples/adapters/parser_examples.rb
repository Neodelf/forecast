# frozen_string_literal: true

RSpec.shared_examples 'a corrected parser' do
  context 'when data is present' do
    it 'returns the temperature in Fahrenheit' do
      expect(adapter.parse(data)).to eq({ temp_f: 72 })
    end
  end

  context 'when data is nil' do
    let(:data) { nil }

    it 'returns nil' do
      expect(adapter.parse(data)).to eq({ temp_f: nil })
    end
  end

  context 'when data is missing "TempF" key' do
    let(:data) { {} }

    it 'returns nil' do
      expect(adapter.parse(data)).to eq({ temp_f: nil })
    end
  end
end
