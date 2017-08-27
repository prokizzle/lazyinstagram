require "sidekiq/throttled"
require 'sidekiq-cron'
Sidekiq::Throttled.setup! 

array = [
    {
        "name": "process_photos",
        "cron": "* * * * *",
        "class": "PhotoAnalysisSchedulerWorker",
        "queue": "analysis"
    },
    {
        "name": "discovery",
        "cron": "*/5 * * * *",
        "class": "DiscoveryWorker",
        "queue": "discovery"
    },
    {
        "name": "like_photos",
        "cron": "*/1 * * * *",
        "class": "PhotoLikerWorker",
        "queue": "instagram_api"
    },
    {
        "name": "follow_users",
        "cron": "*/60 * * * *",
        "class": "ScheduleFollowsWorker",
        "queue": "follows"
    }
]

Sidekiq::Cron::Job.load_from_array array

Sidekiq.configure_server do |config|
    config.redis = { url: "redis://#{ENV['REDIS_SERVER']}:6379/0" }
    # config.redis = { url: "redis://#{ENV['REDIS_SERVER']}:6379/0", password: ENV['REDIS_PASSWORD'] }
end

Sidekiq.configure_client do |config|
    config.redis = { url: "redis://#{ENV['REDIS_SERVER']}:6379/0" }
end
