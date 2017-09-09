module Instagram
    class UserUnfollower < UserFollower
        attr_reader :endpoint, :user_id

        def unfollow!
            response = RestClient.post(endpoint, {action: 'unfollow'})
            results = parse_results(response)
            return false if results['meta']['error_type'].present?
            results['data']['outgoing_status'] == 'none'
        end
    end
end
