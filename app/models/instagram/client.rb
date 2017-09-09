module Instagram
  class Client

    def initialize(distance: 6400)
      @distance = distance
      @timestamp = Time.now.to_i
    end

    def access_token
      ENV['instagram_access_token']
    end

    def timestamp
      @timestamp
    end

    def callback
      "jQuery18304327776299678414_1493603003057&_=1493603007676"
    end

    def auth
        "access_token=#{access_token}&callback=#{callback}"
    end

    def oldest_timestamp(results)
      results['data'].last['created_time'].to_i
    end

    def user_has_liked(photo_id)
      endpoint = "https://api.instagram.com/v1/media/#{photo_id}?#{auth}"
      data = RestClient.get(endpoint)
      return true if parse_results(data)['meta']['error_type'] == 'APINotFoundError'
      return parse_results(data)['data']['user_has_liked']
    end

    def like_media(photo_id)
      endpoint = "https://api.instagram.com/v1/media/#{photo_id}/likes?access_token=#{access_token}&callback=#{callback}"
      RestClient.post(endpoint, {})
    end

    def most_recent_media_ids(user_id)
        endpoint = "https://api.instagram.com/v1/users/#{user_id}/media/recent?#{auth}"
        response = RestClient.get(endpoint)
        data = parse_results(response)
        return [] unless data['data'].present?
        data['data'].map{|d| d['id']}
    end

    def newest_timestamp(results)
      results['data'].first['created_time'].to_i
    end

    def parse_results(data)
      body = data.body.gsub('/**/ jQuery18304327776299678414_1493603003057(', '')
      JSON.parse(body[0...-1])
    end

    def fetch(endpoint = search_endpoint)
      data = RestClient.get(endpoint)
      results = parse_results(data)
      @timestamp = oldest_timestamp(results)
      results
    end
  end
end
