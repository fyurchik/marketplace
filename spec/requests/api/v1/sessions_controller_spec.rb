require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let(:user) { create(:user, password:'password123') }
  let(:valid_token) { JsonWebTokenService.encode(email:user.email) }
  
  let(:invalid_token) {'invalid.token.value' }

  describe "POST /apiv1/session" do
    it "return a valid  token" do
      post '/api/v1/session', params: { email: user.email, password: 'password123' }
       expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key("auth_token")
    end

    it "returns an error" do
      post '/api/v1/session', params: { email: user.email, password: 'wrongpassword' }
      
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("Incorrect Email or Password")
    end
  end

  describe "DELETE /api/v1/session" do
    it "log out the user" do
      delete '/api/v1/session', headers: { 'Authorization': "Bearer #{valid_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("User logged out and session destroyed")
      expect(BlacklistedToken.exists?(token: valid_token)).to be true
    end
  end
end
