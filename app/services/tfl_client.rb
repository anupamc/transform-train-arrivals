require 'httparty'

class TflClient
  include HTTParty
  base_uri 'https://api.tfl.gov.uk'

  def initialize(station_name:)
    @station_name = station_name
  end

  def arrivals
    station_id = fetch_station_id
    return [] unless station_id

    response = self.class.get("/StopPoint/#{station_id}/Arrivals?mode=tube")
    return [] unless response.success?

    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("TfL API Error: #{e.message}")
    []
  end

  private

    def fetch_station_id
      escaped_station_name = ERB::Util.url_encode(@station_name)
      response = self.class.get("/StopPoint/Search/#{escaped_station_name}", query: { modes: "tube" })
      return nil unless response.success?

      data = JSON.parse(response.body)
      data.dig("matches", 0, "id")
    end
end