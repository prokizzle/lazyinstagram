class AnalyzePhotosWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :analysis

  sidekiq_throttle({
                     # Allow maximum 10 concurrent jobs of this class at a time.
                     :concurrency => { :limit => 5 },
                     # Allow maximum 1K jobs being processed within one hour window.
                     :threshold => { :limit => 1_000, :period => 1.day }
  })

  def perform
    photo = InstagramPhoto.where(scraped: [false,nil]).shuffle.sample
    unless photo.nil?
      client = ImageAnalysis::Client.new(url: photo.url, driver: driver)
      if client.bad_image?
        photo.destroy!
      else
        if client.labels_include?('female', 'girl')
          photo.gender = 'female'
          photo.scraped = true
          photo.save
        else
          photo.destroy
        end
      end
    end
  end

  def driver
    "ImageAnalysis::Drivers::#{ENV['analysis_provider'].camelcase}".constantize
  end
end

ProcessPhotosWorker = AnalyzePhotosWorker
