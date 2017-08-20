class DiscoveryWorker
    include Sidekiq::Worker
    include Sidekiq::Throttled::Worker

    sidekiq_options queue: 'discovery'

    sidekiq_throttle({
        :concurrency => { :limit => 1 },
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
