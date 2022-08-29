class MembersController < ApplicationController
    before_action :authenticate_user!
  
    def show
      render json: { user: current_user }, status: :ok
    end

    def all_users
      if current_user.role == 'admin'
        @users = User.all
        render json: @users, status: :ok
      else
        render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
      end 
    end

    def update_user_to_seller
      if current_user.role == 'admin'
        # puts 'got updated'
        @user = User.find(params[:id])

       p @user.update(role: "seller")

        p @user.save
        p @user.errors.full_messages
        
        render json: @user, status: :ok
      else
        render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
      end
    end


  end
