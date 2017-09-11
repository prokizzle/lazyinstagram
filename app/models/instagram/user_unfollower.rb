module Instagram
    class UserUnfollower < UserFollower
        attr_reader :endpoint, :user_id

        def unfollow!
            response = RestClient.post(endpoint, {action: 'unfollow'})
            results = parse_results(response)
            return false if results['meta']['error_type'].present?
            results['data']['outgoing_status'] == 'none'
        end

        def self.queue
            following_ids = Instagram::Account.new.following_ids
            whitelisted_ids = Whitelist.where(instagram_user_id: following_ids).pluck(:instagram_user_id)
            Follow.where.not(
                user_id: whitelisted_ids
            ).where(followed_at: 1.year.ago..3.days.ago, following: true).order(followed_at: :desc)
        end
    end
end
