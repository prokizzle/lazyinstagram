module Instagram
    class Account < Client

        def total_following
            refresh_profile
            @profile['data']['counts']['follows']
        end

        def total_followers
            refresh_profile
            @profile['data']['counts']['followed_by']
        end

        def refresh_profile
            endpoint = "https://api.instagram.com/v1/users/self/?#{auth}"
            @profile =  parse_results(RestClient.get(endpoint))
        end

        def relationships(type)
            endpoint = "https://api.instagram.com/v1/users/self/#{type}?#{auth}"
            results = parse_results(RestClient.get(endpoint))

            users = results['data']
            while results['pagination'].presence
                results = parse_results(RestClient.get(results['pagination']['next_url']))
                users += results['data']
            end
            users
        end

        def following
            relationships('follows')
        end

        def following_ids
            following.pluck('id')
        end

        def followers
            relationships('followed-by')
        end

        def follower_ids
            followers.pluck('id')
        end
    end
end

