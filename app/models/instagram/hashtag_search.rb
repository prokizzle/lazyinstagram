module Instagram
  class HashtagSearch < Client
    def initialize(tag:)
      @tag = tag
    end

    def search_endpoint
      [
        "https://api.instagram.com/v1/tags/#{@tag}/media/recent?",
        "count=100",
        "&max_timestamp=#{@timestamp}",
        "&min_timestamp=",
        "&access_token=#{access_token}",
        "&callback=#{callback}"
      ].join
    end
  end
end
