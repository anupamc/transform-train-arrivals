require 'rails_helper'

RSpec.describe ArrivalsFormatter do
  let(:arrivals) do
    [
      { "platformName" => "Platform 1",
        "destinationName" => "Brixton",
        "lineName" => "Victoria",
        "timeToStation" => 60 },

      { "platformName" => "Platform 1",
        "destinationName" => "Walthamstow",
        "lineName" => "Victoria",
        "timeToStation" => 10 }
    ]
  end

  it "sorts arrivals by time" do
    formatted = described_class.new(arrivals).formatted
    first_train = formatted["Platform 1"].first
    expect(first_train[:destination]).to eq("Walthamstow")
  end
end