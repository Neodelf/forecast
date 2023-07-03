# frozen_string_literal: true

# Wrapper for usage different third-party HTTP libraries for making requests
class HttpClient
  attr_writer :library

  def initialize(library = HttpClients::HttpGem.new)
    @library = library
  end

  def request(method, url, headers, params)
    @library.request(method, url, headers, params)
  end
end
