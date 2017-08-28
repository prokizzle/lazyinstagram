module Instagram
    class UserUnfollower < UserFollower
        attr_reader :endpoint, :user_id

        def unfollow!
            response = RestClient.post(endpoint, {action: 'unfollow'})
            parse_results(response)['data']['outgoing_status'] == 'none'
        end
    end
end
