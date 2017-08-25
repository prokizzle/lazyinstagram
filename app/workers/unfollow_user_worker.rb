class UnfollowUserWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_throttle({
        :concurrency => { :limit => 1 },
        :threshold => { :limit => 5, :period => 12.minutes }
    })

    def perfrom(user_id, instagram_user_id)
        Instagram::Unfollower.new(user_id: user_id).call(instagram_user_id)
    end
end
