require 'rails_helper'

RSpec.describe Api::V1::AdminSessionsController, type: :request do
  let(:admin) { create(:admin, password: 'password123') }
  let(:valid_token) { JsonWebTokenService.encode(email: admin.email, admin: true) }
  let(:invalid_token) { 'invalid.token.value' }

  describe "POST /api/v1/admin_session" do
    it "returns a valid auth token" do
      post '/api/v1/admin_session', params: { email: admin.email, password: 'password123' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key("auth_token")
    end

    it "returns an erro" do
      post '/api/v1/admin_session', params: { email: admin.email, password: 'wrongpassword' }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)["error"]).to eq("invalid email or password")
    end
  end

  describe "DELETE/api/v1/admin_session" do
    it "logs out the admin" do
      delete '/api/v1/admin_session', headers: { 'Authorization': "Bearer #{valid_token}" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("user logged out and session destroyed")
      expect(BlacklistedToken.exists?(token: valid_token)).to be true
    end
  end
end
