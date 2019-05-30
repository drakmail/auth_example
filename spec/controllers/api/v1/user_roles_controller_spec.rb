# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::UserRolesController, type: :controller do
  describe "POST #create" do
    it_behaves_like "check_auth", :post, :create

    context "with auth" do
      include_examples "auth"

      let(:user) { User.create!(username: "admin") }
      let(:role) { Role.create!(title: "reboot the server") }

      context "errors" do
        it "can't assign role to not existing user" do
          post :create, params: { user_role: { user: "not_existing", role: role.title } }

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "can't assign not existing role to user" do
          post :create, params: { user_role: { user: user.username, role: "not_existing" } }

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "can't assign role to user second time" do
          UserRole.create!(user: user, role: role)

          post :create, params: { user_role: { user: user.username, role: role.title } }

          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_UNIQUE"]
        end
      end

      it "assign role to user" do
        post :create, params: { user_role: { user: user.username, role: role.title } }

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
        expect(json_body["user"]).to eq user.username
        expect(json_body["role"]).to eq role.title
        expect(user.roles.where(title: role.title).any?).to eq true
      end

      it "can assign many roles to user" do
        UserRole.create!(user: user, role: role)
        role2 = Role.create!(title: "new_role")

        post :create, params: { user_role: { user: user.username, role: role2.title } }
        expect(response.code).to eq "200"

        expect(user.roles.count).to eq 2
      end
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "check_auth", :delete, :destroy

    context "with auth" do
      include_examples "auth"

      let(:user) { User.create!(username: "admin") }
      let(:role) { Role.create!(title: "reboot the server") }

      context "errors" do
        it "can't remove role from not existing user" do
          delete :destroy, params: { user_role: { user: "not_existing", role: role.title } }

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "can't remove not existing role from user" do
          delete :destroy, params: { user_role: { user: user.username, role: "not_existing" } }

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "can't remove unassigned role from user" do
          delete :destroy, params: { user_role: { user: user.username, role: role.title } }

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end
      end

      it "remove assigned role from user" do
        UserRole.create!(user: user, role: role)

        delete :destroy, params: { user_role: { user: user.username, role: role.title } }

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
        expect(user.roles.where(title: role.title).any?).to eq false
      end
    end
  end
end
