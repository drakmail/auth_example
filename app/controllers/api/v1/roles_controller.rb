# frozen_string_literal: true

class Api::V1::RolesController < ApplicationController
  def create
    role = Role.create!(role_params)
    render json: { success: true, title: role.title }
  end

  protected

  def role_params
    params.require(:role).permit(:title)
  end
end
