# frozen_string_literal: true

class Api::V1::UserPermissionsController < ApplicationController
  def create
    RolePermission.create!(role: user_role, permission: permission)

    render json: { success: true }
  end

  def destroy
    RolePermission.find_by!(role: user_role, permission: permission).destroy!

    render json: { success: true }
  end

  def show
    permissions_list = User.find_by!(username: params[:user]).permissions.order(:id).pluck(:action, :resource).map do |(action, resource)|
      { action: action, resource: resource }.compact
    end

    render json: { success: true, permissions: permissions_list }
  end

  protected

  def user_role
    @_user_role ||= user.roles.for_user.first || user.roles.create!(kind: :for_user)
  end

  def user
    @_user ||= User.find_by!(username: user_permission_params[:user])
  end

  def permission
    @_permission ||= Permission.find_by!(action: user_permission_params[:permission_action],
                                         resource: user_permission_params[:permission_resource])
  end

  def user_permission_params
    params.require(:user_permission).permit(:user, :permission_action, :permission_resource)
  end
end
