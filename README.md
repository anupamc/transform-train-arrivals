# Transform Tube App

Displays next tube arrivals for Great Portland Street.

## Tech Stack
- Ruby 3.x
- Rails 7.x
- HTTParty
- RSpec

## Setup

git clone <repo>
cd transform_tube
bundle install
rails server

Visit:
http://localhost:3000

## Running Tests

bundle exec rspec

## Architecture Notes

- TflClient: Handles API integration
- ArrivalsFormatter: Business logic layer
- MVC separation maintained
- No database required
- Graceful API failure handling

## Trade-offs

- No caching implemented due to short-lived data
- Could introduce Redis for rate limit mitigation
- Could introduce background polling via Turbo Streams