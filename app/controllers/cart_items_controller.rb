class CartItemsController < ApplicationController


  #add to cart by number
  def add_to_cart_by_number
    authenticate_user!
    @cart = Cart.find_by(user_id: current_user.id)
    @product = Product.find(params[:id])
    @cart_item = CartItem.find_by(cart_id: @cart.id, product_id: @product.id)

    # if the product is already in the cart, increase the quantity
    if @cart_item
      @cart_item.quantity += 1
      
      @cart_item.save
      render json: @cart_item, status: :ok
    else
      @cart_item = CartItem.create(cart_id: @cart.id, product_id: @product.id, quantity: 1)
      render json: @cart_item, status: :created
    end
  end

  def all_cart_items
    authenticate_user!
    @cart = Cart.find_by(user_id: current_user.id)
    @cart_items = CartItem.where(cart_id: @cart.id)
    render json: @cart_items, status: :ok
  end

  #delete a product from the cart
  def destroy_cart_item
    authenticate_user!
    @cart = Cart.find_by(user_id: current_user.id)
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    render json: @cart_item, status: :ok
  end

  #increase quantity of a product in the cart by 1
  def increase_quantity
    authenticate_user!
    @cart = Cart.find_by(user_id: current_user.id)
    @cart_item = CartItem.find(params[:id])
    @cart_item.quantity += 1
    @cart_item.save
    render json: @cart_item, status: :ok
  end

  #decresase quantity of a product in the cart by 1 if less than 1 delete the item
  def decrease_quantity
    authenticate_user!
    @cart = Cart.find_by(user_id: current_user.id)
    @cart_item = CartItem.find(params[:id])
    if @cart_item.quantity > 1
      @cart_item.quantity -= 1
      @cart_item.save
      render json: @cart_item, status: :ok
    else
      @cart_item.destroy
      render json: @cart_item, status: :ok
    end
  end

  #all products in the cart
  def cart_products_index
    authenticate_user!
    @cart = Cart.find_by(user_id: current_user.id)
    @cart_items = CartItem.where(cart_id: @cart.id)
    @products = Product.where(id: @cart_items.pluck(:product_id)).joins(:image_attachment)

      @total_cart_price = @cart_items.map { |cart_item| cart_item.quantity * cart_item.product.price }.sum

      @products = @products.map do |product|
        product.attributes.merge(
          image_url: url_for(product.image),
          quantity: @cart_items.find_by(product_id: product.id).quantity,
          total_price: @cart_items.find_by(product_id: product.id).quantity * product.price,
          cartItem_id: @cart_items.find_by(product_id: product.id).id
        )
      end
    
    render json: { products: @products, total_cart_price: @total_cart_price }, status: :ok
  end

end
