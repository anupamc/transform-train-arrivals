require 'rails_helper'

RSpec.describe ArrivalsFormatter do
  let(:arrivals) do
    [
      { "platformName" => "Platform 1",
        "destinationName" => "Brixton",
        "lineName" => "Victoria",
        "timeToStation" => 120 },

      { "platformName" => "Platform 1",
        "destinationName" => "Aldgate",
        "lineName" => "Circle",
        "timeToStation" => 60 },

      { "platformName" => "Platform 2",
        "destinationName" => "Walthamstow",
        "lineName" => "Victoria",
        "timeToStation" => 10 }
    ]
  end

  it "groups arrivals by platform" do
    result = described_class.new(arrivals).formatted
    expect(result.keys).to contain_exactly("Platform 1", "Platform 2")
  end

  it "sorts arrivals by time" do
    formatted = described_class.new(arrivals).formatted
    first_train = formatted["Platform 2"].first
    expect(first_train[:destination]).to eq("Walthamstow")
  end
end