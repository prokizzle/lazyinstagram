require "rails_helper"

RSpec.describe WhitelistsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/whitelists").to route_to("whitelists#index")
    end

    it "routes to #new" do
      expect(:get => "/whitelists/new").to route_to("whitelists#new")
    end

    it "routes to #show" do
      expect(:get => "/whitelists/1").to route_to("whitelists#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/whitelists/1/edit").to route_to("whitelists#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/whitelists").to route_to("whitelists#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/whitelists/1").to route_to("whitelists#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/whitelists/1").to route_to("whitelists#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/whitelists/1").to route_to("whitelists#destroy", :id => "1")
    end

  end
end
