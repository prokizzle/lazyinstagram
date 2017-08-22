require "sidekiq/throttled"
require 'sidekiq-cron'
Sidekiq::Throttled.setup! 

schedule_file = "config/schedule.yml"

if File.exists?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq.configure_server do |config|
      config.redis = { url: "redis://#{ENV[:REDIS_SERVER}:6379/0", password: ENV['REDIS_PASSWORD'] }
end

Sidekiq.configure_client do |config|
      config.redis = { url: "redis://#{ENV[:REDIS_SERVER}:6379/0", password: ENV['REDIS_PASSWORD'] }
end
