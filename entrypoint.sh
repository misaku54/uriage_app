#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /uriage_app/tmp/pids/server.pid
# bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails assets:precompile
# cron実行
bundle exec whenever --update-crontab
service cron start
service cron status
bundle exec rake open_meteo_api:set_weather_forecasts
# bundle exec whenever --update-cron --set environment=development
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"