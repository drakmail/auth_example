# frozen_string_literal: true

class Api::V1::UsersController < ApplicationController
  def create
    user = User.create!(user_params)

    render json: { success: true, username: user.username }
  end

  protected

  def user_params
    params.require(:user).permit(:username)
  end
end
