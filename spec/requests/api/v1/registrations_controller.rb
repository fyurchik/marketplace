require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :request do
  let(:valid_params) do
    { users: { name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'password123' } }
  end

  let(:invalid_params) do
    { users: { name: 'Test User', email: 'test@example.com', password: 'password123', password_confirmation: 'wrongconfirmation' } }
  end

  describe "POST /api/v1/registration" do
    it "creates a new user" do
      post '/api/v1/registration ', params: valid_params
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["success"]).to eq("saved")
      
    end

    
    it "returns an eror" do
      post '/api/v1 registration', params: invalid_params

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to include("password_confirmation")
    end
  end
end
