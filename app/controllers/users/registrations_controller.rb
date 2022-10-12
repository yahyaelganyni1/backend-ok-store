class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix

  respond_to :json


  # create shopping cart for every user
  def create
    super do |resource|
      Cart.create(user_id: resource.id)
    end
    
    first_user = User.first

    first_user.update(role: 'admin')

end

# let the first user be admin

  private

  def respond_with(resource, _opts = {})
    register_success && return if resource.persisted?

    register_failed
  end

  def register_success
    render json: { message: 'Signed up sucessfully.', user: resource }, status: :ok
  end

  def register_failed
    render json: { message: "Something went wrong." }
  end

  def update
    if current_user.update(sign_up_params)
      render json: { message: 'Updated successfully.', user: current_user }, status: :ok
    else
      render json: { message: 'Something went wrong.' }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :role)
  end
end