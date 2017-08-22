class ScrapePhotosByLocationWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_options queue: :scrape_photos, unique: :until_executing

    sidekiq_throttle({
        :concurrency => { :limit => 2 },
        :threshold => { :limit => 750, :period => 15.minutes }
    })

    def perform(latitude, longitude, newest_timestamp, oldest_timestamp = Time.now.to_i)
        return if analysis_queue_full 
        client = Instagram::LocationSearch.new(latitude: latitude, longitude: longitude)
        results = client.fetch
        results['data'].each do |result|
            url = result['images']['standard_resolution']['url']
            photo_id = result['id']
            user_id = result['user']['id']
            tags = result['tags'])
            CreatePhotoWorker.perform_async(url, photo_id, user_id, tags)
        end

        if (client.oldest_timestamp(results) > 1.hours.ago.to_i) && !analysis_queue_full
            ScrapePhotosWorker.perform_async(latitude, longitude, client.oldest_timestamp(results))
        end
    end

    def analysis_queue_full
        InstagramPhoto.where(scraped: nil).size > 600
    end

    def create_location(result)
        location = Location.find_or_create_by(
            latitude: result['location']['latitude'],
            longitude: result['location']['longitude'],
        )
        location.name = result['location']['name']
        location.save
    end
end

ScrapePhotosWorker = ScrapePhotosByLocationWorker
