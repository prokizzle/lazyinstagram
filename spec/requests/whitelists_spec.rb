require 'rails_helper'

RSpec.describe "Whitelists", type: :request do
  describe "GET /whitelists" do
    it "works! (now write some real specs)" do
      get whitelists_path
      expect(response).to have_http_status(200)
    end
  end
end
