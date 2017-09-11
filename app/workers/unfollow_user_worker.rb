class UnfollowUserWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_throttle({
        :concurrency => { :limit => 1 },
        :threshold => { :limit => 3, :period => 12.minutes }
    })

    sidekiq_options({ backtrace: true, unique: :until_executing })

    def perform
        target = Instagram::UserUnfollower.queue.try(:first)
        return if target.nil?
        client = Instagram::UserUnfollower.new(user_id: target.user_id)
        client.unfollow!
        target.following =  client.following?
        target.save
    end
end

UserUnfollowerWorker = UnfollowUserWorker
