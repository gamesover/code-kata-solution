FROM ruby:3.0.0-alpine

WORKDIR /usr/src/app

COPY . .

RUN bundle install

EXPOSE 80

ENV NAME TodoFetcher

CMD ["./fetcher.rb"]