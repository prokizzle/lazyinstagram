class AnalyzePhotosWorker
  include Sidekiq::Worker
  include Sidekiq::Throttled::Worker
  sidekiq_options queue: :analysis

  sidekiq_throttle({
                     # Allow maximum 10 concurrent jobs of this class at a time.
                     :concurrency => { :limit => 5 },
                     # Allow maximum 1K jobs being processed within one hour window.
                     :threshold => { :limit => 600, :period => 1.minute }
  })

  def perform
    photo = InstagramPhoto.where(scraped: [false,nil]).shuffle.sample
    unless photo.nil?
      client = ImageAnalysis::Client.new(url: photo.url, driver: driver)
      if client.bad_image?
        puts "Bad image", photo.url
        # photo.destroy!
      else
        puts client.label_names.inspect, photo.url
        photo.label_list.add(client.label_names)
        if client.labels_include?('female', 'girl')
          photo.gender = 'female'
        end
        photo.scraped = true
        photo.save
      end
    else
      DiscoveryWorker.perform_async
    end
  end

  def driver
    "ImageAnalysis::Drivers::#{ENV['analysis_provider'].camelcase}".constantize
  end
end

ProcessPhotosWorker = AnalyzePhotosWorker
