class ScrapePhotosByHashtagWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker

  sidekiq_options queue: :instagram_api

  sidekiq_throttle({
                     # Allow maximum 10 concurrent jobs of this class at a time.
                     :concurrency => { :limit => 5 },
                     # Allow maximum 1K jobs being processed within one hour window.
                     :threshold => { :limit => 2_000, :period => 1.hour }
  })

  def perform(tag, newest_timestamp, oldest_timestamp = Time.now.to_i)
    # return if InstagramPhoto.where(scraped: nil).size > 0
    client = Instagram::HashtagSearch.new(tag: tag)
    results = client.fetch
    results['data'].each do |result|
      photo = InstagramPhoto.find_or_create_by(
        url: result['images']['standard_resolution']['url'],
        photo_id: result['id'],
        user_id: result['user']['id']
      )
      photo.hashtag_list.add(result['tags'])
      photo.save
    end

    if client.oldest_timestamp(results) > 1.hours.ago.to_i
      ScrapePhotosByHashtagWorker.perform_async(tag, client.oldest_timestamp(results))
    end
  end
end