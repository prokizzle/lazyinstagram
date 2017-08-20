class PhotoAnalysisSchedulerWorker
  include Sidekiq::Worker

  def perform
      InstagramPhoto.where(scraped: nil).count.times { AnalyzePhotosWorker.perform_async }
  end
end
