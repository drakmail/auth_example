# frozen_string_literal: true

class Api::V1::UserRolesController < ApplicationController
  def create
    user = User.find_by!(username: user_role_params[:user])
    role = Role.find_by!(title: user_role_params[:role])

    UserRole.create!(user: user, role: role, kind: :default)

    render json: { success: true, user: user.username, role: role.title }
  end

  def destroy
    user = User.find_by!(username: user_role_params[:user])
    role = Role.find_by!(title: user_role_params[:role])

    UserRole.find_by!(user: user, role: role, kind: :default).destroy!

    render json: { success: true }
  end

  protected

  def user_role_params
    params.require(:user_role).permit(:role, :user)
  end
end
