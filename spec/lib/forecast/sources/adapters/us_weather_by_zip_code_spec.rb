# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast::Sources::Adapters::UsWeatherByZipCode do
  subject(:adapter) { described_class.new }

  describe '#parse' do
    it_behaves_like 'a corrected parser' do
      let(:data) { { 'TempF' => 72 } }
    end
  end
end
