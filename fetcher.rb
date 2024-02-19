#!/usr/bin/env ruby
# frozen_string_literal: true

require 'awesome_print'
require_relative 'lib/todo_fetcher'

todo_fetcher = TodoFetcher.new
puts todo_fetcher.fetch_even_todos(20)
