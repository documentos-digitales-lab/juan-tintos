require "net/http"
require "json"
require "uri"
require "timeout"

class CustomerApi
  # Raised for any failure talking to the dummyjson API: a non-2xx
  # response, a network/connection problem, a timeout, or a malformed
  # response body. Callers only need to rescue this one error class.
  class Error < StandardError; end

  BASE_URL = "https://dummyjson.com/users"
  REQUEST_TIMEOUT = 5 # seconds

  def self.find(customer_id)
    uri = URI("#{BASE_URL}/#{customer_id}")

    response = Timeout.timeout(REQUEST_TIMEOUT) { Net::HTTP.get_response(uri) }

    unless response.is_a?(Net::HTTPSuccess)
      raise Error, "Customer API responded with #{response.code}"
    end

    JSON.parse(response.body)
  rescue Timeout::Error
    raise Error, "Customer API request timed out"
  rescue SocketError, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, OpenSSL::SSL::SSLError => e
    raise Error, "Customer API connection failed: #{e.message}"
  rescue JSON::ParserError => e
    raise Error, "Customer API returned invalid JSON: #{e.message}"
  end
end