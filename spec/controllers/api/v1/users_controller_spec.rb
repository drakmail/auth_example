# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:json_body) { JSON.parse(response.body) }

  describe "POST #create" do
    context "without JWT" do
      it "disallow access" do
        post :create, format: :json

        expect(response.code).to eq "403"
        expect(json_body["success"]).to eq false
        expect(json_body["errors"]).to eq ["AUTH_REQUIRED"]
      end
    end

    context "with JWT" do
      before do
        payload = { sub: :caller }
        auth_token = JWT.encode(payload, nil, "none")
        request.headers["Authorization"] = "Bearer #{auth_token}"
      end

      describe "errors" do
        it "check not empty username parameter" do
          post :create, params: { user: { username: nil } }, format: :json

          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["USERNAME_BLANK"]
        end

        it "check dublicate usernames" do
          existing_username = "GoTech"
          User.create!(username: existing_username)

          post :create, params: { user: { username: existing_username } }, format: :json

          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_UNIQUE"]
        end
      end

      it "creates user" do
        username = "USERNAME"
        post :create, params: { user: { username: username } }, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
        expect(json_body["username"]).to eq username
      end
    end
  end
end
