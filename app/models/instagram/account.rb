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

        def following
            endpoint = "https://api.instagram.com/v1/users/self/follows?#{auth}"
            results = parse_results(RestClient.get(endpoint))

            users = results['data']
            while results['pagination'].presence
                results = parse_results(RestClient.get(results['pagination']['next_url']))
                users += results['data']
            end
            users
        end

        def following_ids
            following.pluck('id')
        end
    end
end

