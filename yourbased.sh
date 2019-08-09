#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y tzdata libpq-dev
brew install postgres
echo $(brew --prefix)
pg_ctl -D $(brew --prefix)/var/postgres start
gem install bundler -v 2.0.1
# install
bundle install --without development production
# before_script
cp config/database.yml.travis config/database.yml
bundle exec rake db:create db:migrate RAILS_ENV=test
bundle exec rake admin:categories:create
# script
rake
