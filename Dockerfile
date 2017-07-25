FROM ruby:2.3

WORKDIR /app
ADD . /app

RUN bundle install
ENV RACK_ENV production
CMD ["bundle", "exec", "pry"]
