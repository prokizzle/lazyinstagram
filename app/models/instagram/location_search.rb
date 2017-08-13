module Instagram
  class LocationSearch < Client

    def initialize(search_term: nil, latitude: nil, longitude: nil, distance: 6400)
      @lat = latitude || Geocoder.coordinates(search_term)[0]
      @lng = longitude || Geocoder.coordinates(search_term)[1]
      super(distance: distance)
    end

    def search_endpoint
      ["https://api.instagram.com/v1/media/search?count=100",
       "&max_timestamp=#{@timestamp}&min_timestamp=&distance=#{@distance}",
       "&lat=#{@lat}&lng=#{@lng}&access_token=#{access_token}",
       "&callback=#{callback}"].join
    end
  end
end
