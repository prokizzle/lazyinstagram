class PhotoLikerWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :instagram_api, backtrace: true, retry: false

  sidekiq_throttle({
                     :concurrency => { :limit => 1 },
                     :threshold => { :limit => 3, :period => 5.minutes }
  })

  def perform
    photo = InstagramPhoto.find_by(liked: false, scraped: true, gender: 'female')
    return if photo.nil?
    if photo.photo_id.nil?
      photo.destroy
      PhotoLikerWorker.perform_async
    else
      client = Instagram::Client.new
      client.like_media(photo.photo_id)
      photo.liked = client.user_has_liked(photo.photo_id)
      photo.save
    end
  end
end
