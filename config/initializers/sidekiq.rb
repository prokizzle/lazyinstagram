require "sidekiq/throttled"
Sidekiq::Throttled.setup! 

schedule_file = "config/schedule.yml"

if File.exists?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

Sidekiq.configure_server do |config|
      config.redis = { url: 'redis://redis-10856.c11.us-east-1-2.ec2.cloud.redislabs.com:10856/1' }
end

Sidekiq.configure_client do |config|
      config.redis = { url: 'redis://redis-10856.c11.us-east-1-2.ec2.cloud.redislabs.com:10856/1' }
end
