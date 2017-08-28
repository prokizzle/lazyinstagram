class UnfollowUserWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_throttle({
        :concurrency => { :limit => 1 },
        :threshold => { :limit => 5, :period => 12.minutes }
    })

    sidekiq_options({ backtrace: true })

    def perform
        following_ids = Instagram::Account.new.following_ids
        whitelisted_ids = Whitelist.where(instagram_user_id: following_ids).pluck(:instagram_user_id)
        targets = Follow.where.not(user_id: whitelisted_ids).where(followed_at: 1.year.ago..5.days.ago, following: true).order(followed_at: :desc)
        target = targets.try(:first)
        return if target.nil?
        Instagram::UserUnfollower.new(user_id: target.user_id).unfollow!
        target.following = false
        target.save
    end
end

UserUnfollowerWorker = UnfollowUserWorker
