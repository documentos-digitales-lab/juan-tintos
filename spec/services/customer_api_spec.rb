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

    it "raises an error when the API request fails" do
      response = instance_double(Net::HTTPResponse)

      allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
      allow(Net::HTTP).to receive(:get_response).and_return(response)

      expect {
        described_class.find(1)
      }.to raise_error("Customer API request failed")
    end
  end
end