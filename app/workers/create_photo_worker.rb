class CreatePhotoWorker
    include Sidekiq::Worker
    sidekiq_options queue: :creations

    def perform(url, photo_id, user_id, tags)
        photo = InstagramPhoto.find_or_create_by(
            url: url,
            photo_id: photo_id,
            user_id: user_id
        )
        photo.hashtag_list.add(tags)
        photo.save
    end
end
