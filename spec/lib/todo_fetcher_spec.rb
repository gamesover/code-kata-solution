# frozen_string_literal: true

require_relative '../../lib/todo_fetcher'

describe TodoFetcher do
  subject { described_class.new }

  let(:mocked_todos) do
    {
      1 => { 'userId' => 1, 'id' => 1, 'title' => 'title 1', 'completed' => false },
      2 => { 'userId' => 2, 'id' => 2, 'title' => 'title 2', 'completed' => false },
      3 => { 'userId' => 3, 'id' => 3, 'title' => 'title 3', 'completed' => true },
      4 => { 'userId' => 4, 'id' => 4, 'title' => 'title 4', 'completed' => true }
    }
  end

  describe '#fetch_even_todos' do
    before do
      mocked_todos.each do |id, todo|
        stub_request(:get, "https://jsonplaceholder.typicode.com/todos/#{id}")
          .to_return(status: 200, body: todo.to_json, headers: {})
      end
    end

    it 'fetches even numbered todos' do
      result = subject.fetch_even_todos(2)
      expect(result).to eq({
                             'title 2' => false,
                             'title 4' => true
                           })
    end

    context 'when API rate limit is exceeded' do
      before do
        TodoFetcher::MAX_RETRIES = 1
        stub_request(:get, 'https://jsonplaceholder.typicode.com/todos/2')
          .to_return(status: 429, body: '', headers: {})
      end
      after do
        TodoFetcher::MAX_RETRIES = 5
      end

      it 'retries fetching todos' do
        expect { subject.fetch_even_todos(1) }.to output(/Rate limit exceeded/).to_stdout
      end
    end

    context 'when an error occurs during fetching' do
      before do
        TodoFetcher::MAX_RETRIES = 1
        stub_request(:get, 'https://jsonplaceholder.typicode.com/todos/2')
          .to_return(status: 500, body: '', headers: {})
      end
      after do
        TodoFetcher::MAX_RETRIES = 5
      end

      it 'handles HTTP errors gracefully' do
        expect { subject.fetch_even_todos(1) }.to output(/HTTP error: 500/).to_stdout
      end
    end
  end
end
