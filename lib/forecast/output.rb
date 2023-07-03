# frozen_string_literal: true

module Forecast
  # Prepares data with source's adapter and needed formatter
  class Output
    include ActiveModel::Validations

    validate :data_presence

    def initialize(data)
      @data = data
    end

    def render
      return {} unless valid?

      data
    end

    private

    attr_reader :data

    def data_presence
      data.all? { |_, value| value.presence }
    end
  end
end
