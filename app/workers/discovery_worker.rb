class DiscoveryWorker
  include Sidekiq::Worker

  def perform

    User.find_each do |user|
      user.locations.each do |location|
        ScrapePhotosByLocationWorker.perform_async(location.latitude, location.longitude, Time.now.to_i)
      end

      # user.hashtags.each do |hashtag|
      # 	ScrapePhotosByHashtagWorker.perform_async(hashtag)
      # end
    end
  end
end
