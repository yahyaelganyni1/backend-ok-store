class MembersController < ApplicationController
    before_action :authenticate_user!
  
    def show
      render json: { message: "If you see this, you're in!", user: current_user, logged_in: true }, status: :ok
    end
  end