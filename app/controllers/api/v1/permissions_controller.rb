# frozen_string_literal: true

class Api::V1::PermissionsController < ApplicationController
  def create
    permission = Permission.create!(permissions_params)

    render json: { success: true, action: permission.action, resource: permission.resource }
  end

  def index
    permissions = Permission.order(:id)

    permissions_list =  permissions.pluck(:action, :resource).map do |(action, resource)|
      { action: action, resource: resource }.compact
    end

    render json: { success: true, permissions: permissions_list }
  end

  def destroy
    permission = Permission.find_by!(action: params[:id])

    permission.destroy!

    render json: { success: true }
  end

  protected

  def permissions_params
    params.require(:permission).permit(:action, :resource)
  end
end
