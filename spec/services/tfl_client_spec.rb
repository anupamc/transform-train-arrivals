require "rails_helper"
require "webmock/rspec"

RSpec.describe TflClient do
  subject(:client) { described_class.new(station_name: station_name) }

  let(:station_name) { "Great Portland Street" }
  let(:escaped_station_name) { ERB::Util.url_encode(station_name) }
  let(:station_id) { "940GZZLUGPS" }

  describe "#arrivals" do
    it "returns parsed arrivals when both API calls succeed" do
      stub_request(:get, "https://api.tfl.gov.uk/StopPoint/Search/#{escaped_station_name}")
        .with(query: { modes: "tube" })
        .to_return(
          status: 200,
          body: { matches: [{ id: station_id }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      stub_request(:get, "https://api.tfl.gov.uk/StopPoint/#{station_id}/Arrivals?mode=tube")
        .to_return(
          status: 200,
          body: [{ lineName: "Circle", destinationName: "Edgware Road" }].to_json,
          headers: { "Content-Type" => "application/json" }
        )

      result = client.arrivals

      expect(result).to eq([{ "lineName" => "Circle", "destinationName" => "Edgware Road" }])
    end

    it "returns an empty array when no station is found" do
      stub_request(:get, "https://api.tfl.gov.uk/StopPoint/Search/#{escaped_station_name}")
        .with(query: { modes: "tube" })
        .to_return(
          status: 200,
          body: { matches: [] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      expect(client.arrivals).to eq([])
    end

    it "returns an empty array when arrivals API fails" do
      stub_request(:get, "https://api.tfl.gov.uk/StopPoint/Search/#{escaped_station_name}")
        .with(query: { modes: "tube" })
        .to_return(
          status: 200,
          body: { matches: [{ id: station_id }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      stub_request(:get, "https://api.tfl.gov.uk/StopPoint/#{station_id}/Arrivals?mode=tube")
        .to_return(status: 503, body: "Service Unavailable")

      expect(client.arrivals).to eq([])
    end

    it "returns an empty array and logs an error when JSON parsing fails" do
      allow(Rails.logger).to receive(:error)

      stub_request(:get, "https://api.tfl.gov.uk/StopPoint/Search/#{escaped_station_name}")
        .with(query: { modes: "tube" })
        .to_return(
          status: 200,
          body: { matches: [{ id: station_id }] }.to_json,
          headers: { "Content-Type" => "application/json" }
        )

      stub_request(:get, "https://api.tfl.gov.uk/StopPoint/#{station_id}/Arrivals?mode=tube")
        .to_return(status: 200, body: "{bad json")

      expect(client.arrivals).to eq([])
      expect(Rails.logger).to have_received(:error).with(/TfL API Error:/)
    end
  end
end