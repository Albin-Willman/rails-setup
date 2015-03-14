require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(:get => "/user/new").to route_to("users#new")
    end

    it "routes to #show" do
      expect(:get => "/user").to route_to("users#show")
    end

    it "routes to #edit" do
      expect(:get => "/user/edit").to route_to("users#edit")
    end

    it "routes to #create" do
      expect(:post => "/user").to route_to("users#create")
    end

    it "routes to #update" do
      expect(:put => "/user").to route_to("users#update")
    end

    it "routes to #destroy" do
      expect(:delete => "/user").to route_to("users#destroy")
    end

  end
end
