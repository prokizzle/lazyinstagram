class PhotoAnalysisSchedulerWorker
	include Sidekiq::Worker

	def perform
		if InstagramPhoto.where(liked: false, scraped: true, gender: 'female').count < 500
			AnalyzePhotosWorker.perform_async
		end
	end
end