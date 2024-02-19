# frozen_string_literal: true

require 'net/http'
require 'json'
require 'concurrent'
require 'redis'
require 'ruby-limiter'
require 'byebug'

class TodoFetcher
  extend Limiter::Mixin

  class TodoFetcherRateLimitReachedError < StandardError; end
  class TodoFetcherGenericError < StandardError; end

  API_BASE_URL = 'https://jsonplaceholder.typicode.com/todos'
  MAX_RETRIES = 5
  BASE_DELAY = 1
  INTERVAL_IN_SECONDS = 60
  EXECUTION_NUMBERS = 60
  RATELIMIT_KEY = 'todos_api_calls'

  limit_method(:fetch_todo_with_retry, rate: EXECUTION_NUMBERS, interval: INTERVAL_IN_SECONDS) do
    puts 'Limit reached'
  end

  def fetch_even_todos(count)
    futures = get_ids(count).map do |id|
      Concurrent::Future.execute { fetch_todo_with_retry(id: id) }
    end
    futures
      .map(&:value)
      .compact
      .map { |todo| parese_future(todo) }
      .to_h
  end

  private

  def parese_future(todo)
    [todo['title'], todo['completed']]
  end

  def get_ids(count)
    (1..count).map { |n| n * 2 }
  end

  def fetch_todo_with_retry(id:, attempt: 0)
    url = "#{API_BASE_URL}/#{id}"
    uri = URI(url)
    response = Net::HTTP.get_response(uri)

    case response
    when Net::HTTPSuccess
      JSON.parse(response.body)
    when Net::HTTPTooManyRequests
      raise TodoFetcherRateLimitReachedError, 'Rate limit exceeded'
    else
      raise TodoFetcherGenericError, "HTTP error: #{response.code}"
    end
  rescue StandardError => e
    handle_error(error: e, id: id, attempt: attempt)
  end

  def handle_error(error:, id:, attempt:)
    puts "Attempt #{attempt + 1}: Error fetching TODO with id #{id}: #{error.message}"
    if attempt < MAX_RETRIES
      sleep(BASE_DELAY * 2**attempt)
      fetch_todo_with_retry(id: id, attempt: attempt + 1)
    else
      puts "Failed to fetch TODO with id #{id} after #{MAX_RETRIES + 1} attempts."
    end
  end
end
