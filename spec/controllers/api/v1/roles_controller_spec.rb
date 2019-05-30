# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::RolesController, type: :controller do
  describe "POST #create" do
    it_behaves_like "check_auth", :post, :create

    context "with auth" do
      include_examples "auth"

      describe "errors" do
        it "check not empty title parameter" do
          post :create, params: { role: { title: nil } }, format: :json

          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["TITLE_BLANK"]
        end

        it "check duplicate title" do
          existing_title = "ADMIN"
          Role.create!(title: existing_title)

          post :create, params: { role: { title: existing_title } }, format: :json

          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_UNIQUE"]
        end
      end

      it "creates role" do
        title = "admin"
        post :create, params: { role: { title: title } }, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
        expect(json_body["title"]).to eq title
      end
    end
  end
end
