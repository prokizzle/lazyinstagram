require "google/cloud/vision"

module ImageAnalysis
  module Drivers
    class GoogleVision < Base
      attr_reader :client, :labels

      def initialize(url:)
        @url = url
        project_id = ENV['google_vision_product_id']
        @client = Google::Cloud::Vision.new(project: project_id)
        @image_labels = client.image(@image_url).labels rescue nil
      end

      def label_names
      	return [] if labels.nil?
        labels.select do |label|
          label.score > 0.5
        end.map { |label| label.description.downcase }.uniq
      end

      def bad_image?
        labels.nil?
      end

      def labels_include?(*labels)
        labels.any? do |label|
          label_names.include?(label)
        end
      end
    end
  end
end
