#!/usr/bin/env bash

set -o errexit

sudo apt-get install libpq-dev

bundle install
bin/rails assets:precompile
bin/rails assets:clean

bin/rails db:migrate
bin/rails db:seed