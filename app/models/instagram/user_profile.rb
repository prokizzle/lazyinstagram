module Instagram
  class UserProfile < Client
    def endpoint
      "https://api.instagram.com/v1/users/self/media/recent?access_token=#{access_token}&callback=#{callback}"
    end


    def locations(next_url: nil)
      puts next_url
      if next_url
        next_endpoint = next_url
      else
        next_endpoint = endpoint
      end
      response = parse_results(RestClient.get(endpoint))
      locations = response['data'].map do |recent_photo|
        recent_photo['location']
      end
      puts response
      next_url = response['pagination']['next_url']
      {next_url: next_url, locations: locations}
    end

    def hashtags
      endpoint = "https://api.instagram.com/v1/users/self/media/recent?access_token=#{access_token}&callback="
      data = RestClient.get(endpoint)
      data = JSON.parse(data.body)['data']
      data.map do |recent_photo|
        recent_photo['tags']
      end
    end
  end
end
