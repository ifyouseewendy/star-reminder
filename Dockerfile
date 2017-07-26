FROM ruby:2.3

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

ADD . .
ENTRYPOINT ["bundle", "exec"]
CMD ["rake", "console"]
