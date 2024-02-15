FROM ruby:3.2-slim

WORKDIR /app
COPY Gemfile* .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      build-essential \
      git \
    && gem install bundler \
    && bundle install \
    && apt-get remove -y build-essential git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . .

EXPOSE 4567
CMD ["puma"]
# CMD ["bundle", "exec", "ruby", "app.rb"]
