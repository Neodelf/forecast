# frozen_string_literal: true

module Forecast
  class Fetcher
    include ActiveModel::Validations

    SOURCES = Forecast::Settings::Sources.sources
    ERRORS_SEPARATOR = ', '
    Result = Struct.new(:success, :data)

    validates :zip_code, numericality: { only_integer: true }, presence: true

    def initialize(zip_code)
      @zip_code = zip_code
    end

    def call
      return error_result unless valid?

      SOURCES.each do |source|
        response = Forecast::Data.new(source.config, zip_code).fetch
        next unless response

        return success_result(source.config[:adapter].parse(response))
      end
    end

    private

    attr_reader :zip_code

    def error_result
      Result.new(false, errors.full_messages.join(ERRORS_SEPARATOR))
    end

    def success_result(data)
      Result.new(true, data)
    end
  end
end
