class PhotoLikerWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :liker, backtrace: true, retry: false

  sidekiq_throttle({
                     :concurrency => { :limit => 1 },
                     :threshold => { :limit => 20, :period => 3.minutes }
  })

  def perform
    photo = InstagramPhoto.where(liked: false, gender: 'female').first
    photo = InstagramPhoto.tagged_with('fitness').where(liked: false).first if photo.nil?
    photo = InstagramPhoto.tagged_with('vacation').where(liked: false).first if photo.nil?
    photo = InstagramPhoto.tagged_with('scottsdale').where(liked: false).first if photo.nil?
    photo = InstagramPhoto.tagged_with('vegas').where(liked: false).first if photo.nil?
    photo = InstagramPhoto.tagged_with('hiking').where(liked: false).first if photo.nil?
    photo = InstagramPhoto.tagged_with('yoga').where(liked: false).first if photo.nil?

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
