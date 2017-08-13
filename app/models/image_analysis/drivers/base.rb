module ImageAnalysis
  module Drivers
    class Base
      def open(url)
        Net::HTTP.get(URI.parse(url))
      end
    end
  end
end
