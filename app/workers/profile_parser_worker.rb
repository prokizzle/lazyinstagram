class ProfileParserWorker
  include Sidekiq::Worker

  def perform
    extract_locations
    extract_hashtags
  end

  def extract_locations(next_url: nil)
    User.find_each do |user|
      locations = profile.locations(next_url: next_url)[:locations]
      _next_url = profile.locations(next_url: next_url)[:next_url]
      puts _next_url
      locations.each do |location|
        loc = Location.find_or_create_by(
          latitude: location['latitude'],
          longitude: location['longitude'],
          user_id: user.id
        )
        loc.name = location['name']
        loc.instagram_id = location['id']
        loc.save
      end
      extract_locations(next_url: _next_url) if _next_url != next_url
    end
  end

  def extract_hashtags
    profile.hashtags.each do |hashtags|
      hashtags.each do |tag|
        hashtag = Hashtag.find_or_create_by(name: tag, user_id: 1)
        UserHashtag.find_or_create_by(
          hashtag_id: hashtag.id,
          user_id: 1,
        )
      end
    end
  end

  def profile
    Instagram::UserProfile.new
  end
end
