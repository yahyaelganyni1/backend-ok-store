class MembersController < ApplicationController
    before_action :authenticate_user!
  
    def show
      render json: { user: current_user }, status: :ok
    end

    def all_users
      @users = User.all
      render json: @users, status: :ok
    end

  end
