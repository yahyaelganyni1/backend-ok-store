class CartsController < ApplicationController
  def show
    authenticate_user!
    @cart = Cart.find_by(user_id: current_user.id)
    @cart_items_total_price = @cart.cart_items.map { |cart_item| cart_item.quantity * cart_item.product.price }.sum
    render json: { cart: @cart, cart_total: @cart_items_total_price }, status: :ok
  end



end
