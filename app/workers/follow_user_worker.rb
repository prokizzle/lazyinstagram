class FollowUserWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_throttle({
        :concurrency => { :limit => 1 },
        :threshold => { :limit => 4, :period => 15.minutes }
    })

    def perform(user_id)
        follow = Follow.find_or_create_by(user_id: user_id)
        return if follow.following?
        user_follower = Instagram::UserFollower.new(user_id: user_id)
        following = user_follower.following?
        follow.following = user_follower.following?
        follow.followed_back = user_follower.follows_me?

        unless following
            user_follower.follow
            follow.followed_at = DateTime.now
            follow.follows += 1
        end

        follow.save
    end
end
