require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  let!(:user) {create(:user) }
  let!(:admin) {create(:admin)}
  let!(:post_record) {create(:post,user: user)}

  describe "GET /api/v1/posts " do
    it "returns all posts for auth user" do
      get "/api/v1/posts", headers: auth_header(user)
      expect(response).to have_http_status(:success)
      expect(json.size).to eq(1)
    end

    it "retur unauthorized status" do
      get "/api/v1/posts"
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "POSt /api/v1/posts" do
    context "for logged in user" do
      let(:attrs) do
        {
          post: {
            brand: "BMW",
            model: "M3",
            body_type: "Sedan",
            mileage: 40000,
            color: "Red",
            price: 1200,
            fuel: "Gas",
            year: 2019,
            engine_capacity: 1.5,
            phone_number: "06693",
            name: "Yura"
          }
        }
      end

      it "creates a new post" do
        post "/api/v1/posts", headers: auth_header(user), params: attrs
        expect(response).to have_http_status(:created)
        expect(json['brand']).to eq("BMW")
      end
    end

    describe "patch /api/v1/posts/:id" do
      it "updates a post" do
        patch "/api/v1/posts/#{post_record.id}", headers: auth_header(user), params: { post: { price: 13000 } }
        expect(response).to have_http_status(:success)
        expect(post_record.reload.price).to eq(13000)
      end
    end

    describe "DELRTE/api/v1/posts/:id" do
      it "deletes a post" do
        expect {
          delete "/api/v1/posts/#{post_record.id}", headers: auth_header(user)
        }.to change(Post, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
