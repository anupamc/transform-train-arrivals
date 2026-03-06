class ArrivalsFormatter
  def initialize(arrivals)
    @arrivals = arrivals
  end

  def formatted
    sorted_arrivals
      .group_by { |a| a["platformName"] }
      .transform_values do |trains|
      trains.map do |train|
        {
          destination: train["destinationName"],
          line: train["lineName"],
          due_in: seconds_to_minutes(train["timeToStation"])
        }
      end
    end
  end

  private

    def sorted_arrivals
      @arrivals.sort_by { |a| a["timeToStation"] }
    end

    def seconds_to_minutes(seconds)
      minutes = seconds / 60
      minutes.zero? ? "Due" : "#{minutes} min"
    end
end