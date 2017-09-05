class PhotoLikerWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :liker, backtrace: true, retry: false

  sidekiq_throttle({
                     :concurrency => { :limit => 1 },
                     :threshold => { :limit => 3, :period => 3.minutes }
  })

  def perform
    photo = InstagramPhoto.where(liked: false, gender: 'female').first
    tags = ['fitness', 'yoga', 'vacation', 'scottsdale', 'vegas', 'female', 'girl', 'woman', 'bikini', 'yoga', 'fashionista', 'hiking']
    photo = InstagramPhoto.tagged_with(tags, any: true).where(liked: false).first if photo.nil?
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
