class CreateUserWorker
  include Sidekiq::Worker
  sidekiq_options queue: :creations

  def perform(options)
    user = InstagramUser.find_or_create_by(username: options['username'])
    user.update(instagram_id: options['instagram_id'])
    user.save
    InstagramPhoto.find_or_create_by(url: options['url'])
  end
end
