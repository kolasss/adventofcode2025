FROM ruby:3.4.7-alpine

LABEL Name=adventofcode2025 Version=0.1.0

RUN apk add --update \
    build-base \
    git

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . /app
