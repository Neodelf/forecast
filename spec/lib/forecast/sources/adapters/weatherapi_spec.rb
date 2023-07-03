# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Forecast::Sources::Adapters::Weatherapi do
  subject(:adapter) { described_class.new }

  describe '#parse' do
    it_behaves_like 'a corrected parser' do
      let(:data) { { 'current' => { 'temp_f' => 72 } } }
    end
  end
end
