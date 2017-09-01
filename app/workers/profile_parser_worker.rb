class ProfileParserWorker
    include Sidekiq::Worker

    def perform
        media = Instagram::Account.new.media
        extract_locations(media)
        extract_hashtags(media)
    end

    def extract_locations(media)
        User.find_each do |user|
            locations = media.map{|m| m['location']}.reject(&:nil?)
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
        end
    end

    def extract_hashtags(media)
        User.find_each do |user|
            hashtags = media.map{|m| m['tags']}.reject(&:nil?).flatten.uniq
            hashtags.each do |tag|
                hashtag = Hashtag.find_or_create_by(name: tag)
                UserHashtag.find_or_create_by(
                    hashtag_id: hashtag.id,
                    user_id: user.id,
                )
            end
        end
    end
end
