# Transform Tube App

Displays next tube arrivals for Great Portland Street.

## Tech Stack
- Ruby 3.x
- Rails 7.x
- HTTParty
- RSpec

## Setup

```bash
git clone git@github.com:anupamc/transform-train-arrivals.git  
cd transform-train-arrivals  
```

Run the setup script:

```bash
bin/setup
```

Start the application:

```bash
bin/rails server
```

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