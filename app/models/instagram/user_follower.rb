module Instagram
    class UserFollower < Client
        attr_reader :endpoint, :user_id

        def initialize(user_id:)
            @endpoint = "https://api.instagram.com/v1/users/#{user_id}/relationship?access_token=#{access_token}&callback=#{callback}"
            @user_id = user_id
        end


        def follow
            response = RestClient.post(endpoint, {action: 'follow'})
            parse_results(response)['data']['outgoing_status'] == 'follows'
        end

        def following?
            response = RestClient.get(endpoint) 
            parse_results(response)['data']['outgoing_status'] == 'follows'
        end

        def follows_me?
            response = RestClient.get(endpoint)
            parse_results(response)['data']['incoming_status'] == 'followed_by'
        end
    end
end
