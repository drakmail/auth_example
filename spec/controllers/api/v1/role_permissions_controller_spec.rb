# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::RolePermissionsController, type: :controller do
  describe "POST #create" do
    it_behaves_like "check_auth", :post, :create

    context "with auth" do
      include_examples "auth"

      let(:role) { Role.create!(title: "title") }
      let(:permission) { Permission.create!(action: "action", resource: "resource") }
      let(:role_title) { role.title }
      let(:permission_action) { permission.action }
      let(:permission_resource) { permission.resource }

      let(:params) do
        {
          role_permission: {
            role_title: role_title,
            permission_action: permission_action,
            permission_resource: permission_resource
          }
        }
      end

      context "errors" do
        describe "empty role" do
          let(:role_title) { nil }

          it "disallowed" do
            post :create, params: params, format: :json
            
            expect(response.code).to eq "404"
            expect(json_body["success"]).to eq false
            expect(json_body["errors"]).to eq ["NOT_FOUND"]
          end
        end

        describe "empty permission" do
          let(:permission_action) { nil }
          let(:permission_resource) { nil }

          it "disallowed" do
            post :create, params: params, format: :json
            
            expect(response.code).to eq "404"
            expect(json_body["success"]).to eq false
            expect(json_body["errors"]).to eq ["NOT_FOUND"]
          end
        end

        it "check uniquiness of role / permission" do
          RolePermission.create!(role: role, permission: permission)

          post :create, params: params, format: :json
          
          expect(response.code).to eq "400"
          expect(json_body["success"]).to eq false
          expect(json_body["errors"]).to eq ["NOT_UNIQUE"]
        end
      end

      it "granting permissions to role" do
        post :create, params: params, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
      end
    end
  end

  describe "DELETE #destroy" do
    it_behaves_like "check_auth", :delete, :destroy

    context "with auth" do
      include_examples "auth"

      let(:role) { Role.create!(title: "title") }
      let(:permission) { Permission.create!(action: "action", resource: "resource") }
      let(:role_title) { role.title }
      let(:permission_action) { permission.action }
      let(:permission_resource) { permission.resource }

      let(:params) do
        {
          role_permission: {
            role_title: role_title,
            permission_action: permission_action,
            permission_resource: permission_resource
          }
        }
      end

      context "errors" do
        describe "empty role" do
          let(:role_title) { nil }

          it "disallowed" do
            delete :destroy, params: params, format: :json
            
            expect(response.code).to eq "404"
            expect(json_body["success"]).to eq false
            expect(json_body["errors"]).to eq ["NOT_FOUND"]
          end
        end

        describe "empty permission" do
          let(:permission_action) { nil }
          let(:permission_resource) { nil }

          it "disallowed" do
            delete :destroy, params: params, format: :json
            
            expect(response.code).to eq "404"
            expect(json_body["success"]).to eq false
            expect(json_body["errors"]).to eq ["NOT_FOUND"]
          end
        end
      end

      it "remove permissions from role" do
        RolePermission.create!(role: role, permission: permission)

        delete :destroy, params: params, format: :json

        expect(response.code).to eq "200"
        expect(json_body["success"]).to eq true
      end
    end
  end
end
