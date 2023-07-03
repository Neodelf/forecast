# frozen_string_literal: true

module HttpClients
  # Base class for future http clients for making requests
  class Base
    def request(method, url, headers, params)
      raise NotImplementedError, "#{self.class} must implement the 'request' method."
    end
  end
end
