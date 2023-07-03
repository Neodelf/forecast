# frozen_string_literal: true

module HttpClients
  # Wrapper for the http gem
  class HttpGem < Base
    def request(method, url, headers, params)
      case method
      when :get
        HTTP.headers(headers).get(url, params:).to_s
      else
        raise ArgumentError, "Unsupported HTTP method: #{method}"
      end
    end
  end
end
