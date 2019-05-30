# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::UserPermissionsController, type: :controller do
  # logic:
  # Caller can get all user permissions with filter (GET show)
  describe "POST #create" do
    it_behaves_like "check_auth", :post, :create

    context "with auth" do
      include_examples "auth"

      let(:user) { User.create!(username: "username") }
      let(:permission) { Permission.create!(action: "reboot", resource: "the_server") }

      context "errors" do
        it "handle not existing permissions" do
          post :create, params: { user_permission: { user: user.username, permission_action: "reboot the server" } }, format: :json

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "handle not existing users" do
          post :create, params: { user_permission: { user: "not_existing", permission_action: permission.action, permission_resource: permission.resource } }, format: :json

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end
      end

      it "assign permissions to user" do
        post :create, params: { user_permission: { user: user.username, permission_action: permission.action, permission_resource: permission.resource } }, format: :json

        expect(response.code).to eq "200"
        expect(user.permissions.where(action: permission.action, resource: permission.resource).any?).to eq true
      end
    end
  end

  describe "DELETE #desstroy" do
    it_behaves_like "check_auth", :delete, :destroy

    context "with auth" do
      include_examples "auth"

      let(:user) { User.create!(username: "username") }
      let(:permission) { Permission.create!(action: "reboot", resource: "the_server") }

      context "errors" do
        it "handle not existing permissions" do
          delete :destroy, params: { user_permission: { user: user.username, permission_action: "reboot the server" } }, format: :json

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "handle not existing users" do
          delete :destroy, params: { user_permission: { user: "not_existing", permission_action: permission.action, permission_resource: permission.resource } }, format: :json

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "handle unassigned permissions" do
          delete :destroy, params: { user_permission: { user: user.username, permission_action: permission.action, permission_resource: permission.resource } }, format: :json

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end
      end

      it "remove assigned permissions" do
        user_role = user.roles.create!(kind: :for_user, permissions: [permission])

        delete :destroy, params: { user_permission: { user: user.username, permission_action: permission.action, permission_resource: permission.resource } }, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
      end
    end
  end

  describe "GET #show" do
    it_behaves_like "check_auth", :get, :show

    context "with auth" do
      include_examples "auth"

      let(:user) { User.create!(username: "username") }
      let(:permission) { Permission.create!(action: "reboot", resource: "the_server") }

      context "for non existing user" do
        it "return error" do
          get :show, params: { user: "not_existing" }, format: :json

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end
      end

      context "without permissions" do
        it "return empty list" do
          get :show, params: { user: user.username }, format: :json

          expect(response.code).to eq "200"
          expect(json_body["permissions"]).to eq []
        end
      end

      context "with permissions" do
        it "return list of permissions" do
          permissions_list = [
            { "action" => "reboot the server" },
            { "action" => "read", "resource" => 'C:\\example.txt' }
          ]
          permissions = permissions_list.map { |permission| Permission.create!(permission) }
          user.roles.create!(kind: :for_user, permissions: permissions)
          # check handling of duplicate permissions for roles in different scopes
          user.roles.create!(kind: :default, title: "special case", permissions: permissions.first(1))

          get :show, params: { user: user.username }, format: :json

          expect(response.code).to eq "200"
          expect(json_body["permissions"]).to eq permissions_list
        end
      end
    end
  end
end
