class LikePhotoWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :liker, backtrace: true, retry: false, unique: :until_executing

  sidekiq_throttle({
                     :concurrency => { :limit => 1 },
                     :threshold => { :limit => 3, :period => 3.minutes }
  })

    def perform(photo_id)
      client = Instagram::Client.new
      client.like_media(photo_id)
    end
end
