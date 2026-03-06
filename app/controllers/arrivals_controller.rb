class ArrivalsController < ApplicationController
  def index
    client = TflClient.new(station_name: "Great Portland Street")
    raw_arrivals = client.arrivals

    Rails.logger.debug raw_arrivals.inspect

    formatter = ArrivalsFormatter.new(raw_arrivals)
    @arrivals = formatter.formatted
  end
end