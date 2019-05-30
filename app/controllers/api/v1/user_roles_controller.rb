# frozen_string_literal: true

class Api::V1::UserRolesController < ApplicationController
  def create
    UserRole.create!(user: user, role: role)

    render json: { success: true, user: user.username, role: role.title }
  end

  def destroy
    UserRole.find_by!(user: user, role: role).destroy!

    render json: { success: true }
  end

  protected

  def user
    @_user ||= User.find_by!(username: user_role_params[:user])
  end

  def role
    @_role ||= Role.default.find_by!(title: user_role_params[:role])
  end

  def user_role_params
    params.require(:user_role).permit(:role, :user)
  end
end
