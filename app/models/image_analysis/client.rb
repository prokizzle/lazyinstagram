require 'forwardable'

module ImageAnalysis
  class Client
  	extend Forwardable
  	attr_reader :cloud_driver

    def initialize(url:, driver:)
      @url = url
      @cloud_driver = driver.new(url: url)
    end

    def open(url)
      Net::HTTP.get(URI.parse(url))
    end

    def_delegator :cloud_driver, :bad_image?
    def_delegator :cloud_driver, :labels_include?
    def_delegator :cloud_driver, :label_names
  end
end
