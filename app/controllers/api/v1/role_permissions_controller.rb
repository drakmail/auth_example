# frozen_string_literal: true

class Api::V1::RolePermissionsController < ApplicationController
  def create
    RolePermission.create!(role: role, permission: permission)

    render json: { success: true }
  end

  def destroy
    RolePermission.find_by!(role: role, permission: permission).destroy!

    render json: { success: true }
  end

  protected

  def role
    @_role ||= Role.find_by!(title: role_permission_params[:role_title])
  end

  def permission
    @_permission ||= Permission.find_by!(action: role_permission_params[:permission_action],
                                         resource: role_permission_params[:permission_resource])
  end

  def role_permission_params
    params.require(:role_permission).permit(:role_title, :permission_action, :permission_resource)
  end
end
