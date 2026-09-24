require "net/http"
require "json"
require "uri"

class CustomerApi
  BASE_URL = "https://dummyjson.com/users"

  def self.find(customer_id)
    uri = URI("#{BASE_URL}/#{customer_id}")

    response = Net::HTTP.get_response(uri)

    raise "Customer API request failed" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end