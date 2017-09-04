FROM starefossen/ruby-node:latest

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.2/supercronic-linux-amd64 \
    SUPERCRONIC=supercronic-linux-amd64 \
    SUPERCRONIC_SHA1SUM=cdfde14f50a171cbfc35a3a10429e2ab0709afe0
RUN curl -fsSLO "$SUPERCRONIC_URL" \
 && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
 && chmod +x "$SUPERCRONIC" \
 && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
 && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic

ENV VIRTUAL_HOST=starreminder.com
WORKDIR /app

RUN npm install -g yarn
COPY package.json yarn.lock ./
RUN yarn

COPY Gemfile Gemfile.lock ./
ENV BUNDLE_GEMFILE=/app/Gemfile \
    BUNDLE_JOBS=2 \
    BUNDLE_PATH=/bundle
RUN bundle install --without development test
ADD . .

RUN bundle exec whenever > /tmp/crontab

RUN yarn run webpack

RUN mkdir -p log

RUN touch /tmp/empty.env
CMD bundle exec foreman start --env /tmp/empty.env
