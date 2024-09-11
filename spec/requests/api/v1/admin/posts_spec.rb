require 'rails_helper'

RSpec.describe "Api::V1::Admin::Posts", type: :request do
  let!(:user) { create(:user) }
  let!(:admin) {create(:admin) }
  let!(:post) { create(:post, user:user, status:"pending")}

  describe "POST /api/v1/admin/posts/:id/update_status" do
    context "for a logged-in admin" do
      it "updates the status of a post" do
        patch "/api/v1/admin/posts/#{post.id}/update_status", headers: auth_header(admin, true), params: { post: {status:"approved"}}
        expect(response).to have_http_status(:success)
        expect(post.reload.status).to eq("approved")
      end
    end

    context "for a non-admin user" do
      it "fails to update the status" do
        patch "/api/v1/admin/posts/#{post.id}/update_status", headers: auth_header(user), params:{ ost:{status:"approved" }}
        expect(response).to (have_http_status(:unauthorized))
      end
    end
  end
end
