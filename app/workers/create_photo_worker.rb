class CreatePhotoWorker
    include Sidekiq::Worker
    sidekiq_options queue: :creations

    def perform(url, photo_id, user_id, tags)
        photo = InstagramPhoto.find_or_create_by(
            url: result['images']['standard_resolution']['url'],
            photo_id: result['id'],
            user_id: result['user']['id']
        )
        photo.hashtag_list.add(result['tags'])
        photo.save
    end
end
