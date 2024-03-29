# Thanks to Cloud66 Starter for the inspiration
FROM ruby:3.1.0

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn 

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# This installs bundler 2x. Change if you need any of the older versions
RUN gem install bundler:2.3.5
ADD Gemfile* $APP_HOME/
# This is a bundler 2 format. For bundler 1, you can add --without development test to the bundle install line
RUN bundle config set without 'development test'
RUN bundle install

EXPOSE 3000

ADD . $APP_HOME
# if you're not using webpack, you can comment out the following line
RUN yarn install --check-files
