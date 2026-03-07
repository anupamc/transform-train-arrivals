require "rails_helper"

RSpec.describe "Arrivals", type: :request do
  describe "GET /" do
    let(:formatted_arrivals) do
      {
        "Eastbound - Platform 2" => [
          { line: "Circle", destination: "Edgware Road", due_in: "2 min" }
        ]
      }
    end

    before do
      allow(TflClient).to receive_message_chain(:new, :arrivals).and_return([])
      allow(ArrivalsFormatter).to receive_message_chain(:new, :formatted).and_return(formatted_arrivals)
    end

    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:ok)
    end

    it "renders the arrivals view" do
      get "/"
      expect(response.body).to include("Great Portland Street - Next Tube Arrivals")
    end
  end
end