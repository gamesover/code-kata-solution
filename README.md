# TodoFetcher CLI Tool

## Overview

`TodoFetcher` is a command-line tool written in Ruby that fetches the first 20 even-numbered TODOs from the JSONPlaceholder API, displaying each TODO's title and completion status.

## Getting Started

### Prerequisites

- Ruby 3.0.0
- Bundler
- Internet connection for fetching TODOs

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/gamesover/code-kata-solution
   ```
2. Navigate to the project directory:
   ```bash
   cd code-kata-solution
   ```
3. Install dependencies:
   ```bash
   bundle install
   ```

### Usage

Run the tool with:
```bash
./fetcher.rb
```

## Features

- Efficiently fetches even-numbered TODOs using concurrent HTTP requests.
- Rate-limiting to avoid API throttling.
- Error handling for rate limits and HTTP errors.
- Extensible design for future enhancements.

## Testing

This project includes both unit and integration tests.

Run tests with:
```bash
rspec
```

## Docker (Bonus)

A `Dockerfile` and `docker-compose.yml` are included for running the tool in a Docker container.

Run using Docker Compose:
```bash
docker-compose up
```

## Submission

This project is submitted as part of the Zepto Code Challenge. It demonstrates my approach to solving the provided problem with a focus on clean code, performance, and scalability.

## Future Improvements

- Extend functionality to fetch TODOs based on user input.
- Implement caching to improve performance for repeated requests.
- Create a more interactive CLI experience.
