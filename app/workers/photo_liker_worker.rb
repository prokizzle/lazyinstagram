class PhotoLikerWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :liker, backtrace: true, retry: false

  sidekiq_throttle({
                     :concurrency => { :limit => 1 },
                     :threshold => { :limit => 10, :period => 3.minutes }
  })

  def perform
    photo = InstagramPhoto.females.where(scraped: true, liked: false).order(id: :desc).first
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
