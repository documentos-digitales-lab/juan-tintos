require "rails_helper"

RSpec.describe CustomerApi do
  describe ".find" do
    it "returns customer data from the API" do
      response = instance_double(
        Net::HTTPResponse,
        body: '{"id":1,"firstName":"James","lastName":"Davis"}'
      )

      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      allow(Net::HTTP).to receive(:get_response).and_return(response)

      result = described_class.find(1)

      expect(result["id"]).to eq(1)
      expect(result["firstName"]).to eq("James")
      expect(result["lastName"]).to eq("Davis")
    end

    it "raises when the API responds with an error status" do
      response = instance_double(Net::HTTPResponse, code: "500")

      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      allow(Net::HTTP).to receive(:get_response).and_return(response)

      expect {
        described_class.find(1)
      }.to raise_error(CustomerApi::Error, "Customer API responded with 500")
    end

    it "raises when the request times out" do
      allow(Net::HTTP).to receive(:get_response).and_raise(Timeout::Error)

      expect {
        described_class.find(1)
      }.to raise_error(CustomerApi::Error, "Customer API request timed out")
    end

    it "raises when the connection fails" do
      allow(Net::HTTP).to receive(:get_response).and_raise(SocketError, "getaddrinfo failed")

      expect {
        described_class.find(1)
      }.to raise_error(CustomerApi::Error, /Customer API connection failed/)
    end

    it "raises when the response body is not valid JSON" do
      response = instance_double(Net::HTTPResponse, body: "not json")

      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
      allow(Net::HTTP).to receive(:get_response).and_return(response)

      expect {
        described_class.find(1)
      }.to raise_error(CustomerApi::Error, /Customer API returned invalid JSON/)
    end
  end
end