class UserPhotoLikerWorker
	include Sidekiq::Worker

	def perform
		InstagramUser.find_each do |user|
			photo InstagramClient.first_photo(user)
			InstagramClient.like_photo(photo.id)
		end
	end
end