class DiscoveryWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_options queue: :discovery

    sidekiq_throttle({
        # Allow maximum 10 concurrent jobs of this class at a time.
        :concurrency => { :limit => 5 },
        # Allow maximum 1K jobs being processed within one hour window.
        :threshold => { :limit => 1, :period => 1.minute }
    })

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
