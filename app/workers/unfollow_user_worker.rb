class UnfollowUserWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_throttle({
        :concurrency => { :limit => 1 },
        :threshold => { :limit => 5, :period => 12.minutes }
    })

    def perform
        following_ids = Instagram::Account.new.following_ids
        whitelisted_ids = Whitelist.where(instagram_user_id: following_ids).pluck(:instagram_user_id)
        target = Follow.where.not(user_id: whitelisted_ids).where(followed_at: 1.year.ago..5.days.ago).order(followed_at: :desc).first
        Instagram::UserUnfollower.new(user_id: target.user_id).unfollow!
    end
end

UserUnfollowerWorker = UnfollowUserWorker
