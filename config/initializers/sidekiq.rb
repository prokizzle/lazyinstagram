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
        "name":"unfollow_users",
        "cron":"*/5 * * * *",
        "class":"UnfollowUserWorker",
        "queue":"follows"
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
        "class": "SchedulePhotoLikesWorker",
        "queue": "instagram_api"
    },
    {
        "name": "follow_users",
        "cron": "*/60 * * * *",
        "class": "ScheduleFollowsWorker",
        "queue": "follows"
    },
    {
        "name":"pg_query",
        "cron":"*/60 * * * *",
        "class":"PgQueryWorker",
        "queue":"default"
    }
]

Sidekiq::Cron::Job.load_from_array array

redis_conn = proc {
      Redis.new(host: ENV['REDIS_SERVER'], port: 6379, db: 0)
}
Sidekiq.configure_client do |config|
      config.redis = ConnectionPool.new(size: 5, &redis_conn)
end
Sidekiq.configure_server do |config|
      config.redis = ConnectionPool.new(size: 10, &redis_conn)
end

