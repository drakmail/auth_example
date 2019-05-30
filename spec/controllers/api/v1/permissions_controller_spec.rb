# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::PermissionsController, type: :controller do
  describe "POST #create" do
    it_behaves_like "check_auth", :post, :create

    context "with auth" do
      include_examples "auth"

      context "errors" do
        it "check action is not empty" do
          post :create, params: { permission: { action: nil } }, format: :json

          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["ACTION_BLANK"]
        end

        it "check action unique" do
          existing_action = "reboot the server"
          Permission.create!(action: existing_action)

          post :create, params: { permission: { action: existing_action } }, format: :json

          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_UNIQUE"]
        end

        it "allow same action for different resources (with empty resource)" do
          existing_action = "reboot the server"
          Permission.create!(action: existing_action, resource: :resource_1)

          post :create, params: { permission: { action: existing_action } }, format: :json

          expect(response.code).to eq "200"
          expect(json_body["success"]).to eq true
          expect(json_body["action"]).to eq existing_action
          expect(json_body["resource"]).to eq nil
        end

        it "allow same action for different resources (with non empty resource)" do
          existing_action = "reboot the server"
          Permission.create!(action: existing_action, resource: :resource_1)

          post :create, params: { permission: { action: existing_action, resource: :resource_2 } }, format: :json

          expect(response.code).to eq "200"
          expect(json_body["success"]).to eq true
          expect(json_body["action"]).to eq existing_action
          expect(json_body["resource"]).to eq "resource_2"
        end
      end

      it "creates new permission with empty resource" do
        action_name = "reboot the server"

        post :create, params: { permission: { action: action_name } }, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
        expect(json_body["action"]).to eq action_name 
        expect(json_body["resource"]).to eq nil
      end

      it "creates new permission for given resource" do
        action_name = "reboot the server"
        resource_name = "server_1"

        post :create, params: { permission: { action: action_name, resource: resource_name } }, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
        expect(json_body["action"]).to eq action_name 
        expect(json_body["resource"]).to eq resource_name
      end
    end
  end

  describe "GET #show" do
    it_behaves_like "check_auth", :get, :show

    context "with auth" do
      include_examples "auth"

      it "return empty list without permissions" do
        get :show, format: :json

        expect(response.code).to eq "200"
        expect(json_body["permissions"]).to eq []
      end

      it "return existing permissions" do
        permission_1 = { "action" => "reboot the server" }
        permission_2 = { "action" => "read", "resource" => 'C:\\example.txt' }
        permissions = [permission_1, permission_2]

        permissions.each { |permission| Permission.create!(permission) }

        get :show, format: :json

        expect(response.code).to eq "200"
        expect(json_body["permissions"]).to eq permissions
      end
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "check_auth", :delete, :destroy

    context "with auth" do
      include_examples "auth"

      context "errors" do
        it "disallow deletion of not existing permission" do
          delete :destroy, params: { permission: { action: "unexisting_action_name" } }, format: :json

          expect(response.code).to eq "404"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_FOUND"]
        end

        it "disallow deletion of used permissions" do
          permission_action = "reboot the server"
          permission = Permission.create!(action: permission_action)
          role = Role.create!(title: "admin")
          RolePermission.create!(permission: permission, role: role)

          delete :destroy, params: { permission: { action: permission_action } }, format: :json

          expect(response.code).to eq "403"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_ALLOWED", "IN_USAGE"]
        end
      end

      it "remove existing permission" do
        action_name = "remove me"
        Permission.create!(action: action_name)

        delete :destroy, params: { permission: { action: action_name } }, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
      end
    end
  end
end
