class SchedulePhotoLikesWorker
  include Sidekiq::Worker
  sidekiq_options queue: :liker, backtrace: true, retry: false


  def perform
    like_photos_by_tags
    # like_photos_from_feed
  end

  def like_photos_by_tags
    photo = InstagramPhoto.where(liked: false, gender: 'female').first
    tags = ['fitness', 'yoga', 'vacation', 'scottsdale', 'arizona', 'california', 'beach', 'atx', 'female', 'girl', 'woman', 'bikini', 'yoga', 'fashionista', 'hiking']
    photo = InstagramPhoto.with_any_tags(tags).where(liked: false).first if photo.nil?
    return if photo.nil?

    if photo.photo_id.nil?
      photo.destroy
      SchedulePhotoLikesWorker.perform_async
    else
      LikePhotoWorker.perform_async(photo.photo_id)
    end
  end

  def client
      @client ||= Instagram::Client.new
  end

  def like_photos_from_feed
    following_ids = Instagram::Account.new.following_ids
    following_ids.each do |id|
        photo_id = client.most_recent_media_ids(id).first
        next if photo_id.nil?
        LikePhotoWorker.perform_async(photo_id)
    end
  end
end



PhotoLikerWorker = SchedulePhotoLikesWorker
