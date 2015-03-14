require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    before(:each) do
      allow_any_instance_of(ApplicationController).to receive(:require_user).and_return(true)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(User.new)
    end
    it "works! (now write some real specs)" do
      get user_path
      expect(response).to have_http_status(200)
    end
  end
end
