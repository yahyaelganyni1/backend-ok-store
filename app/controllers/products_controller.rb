class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show update destroy ]
  # GET /products
  def index
    @products = Product.all

    render json: @products
  end

  # GET /products/1
  def show
    render json: @product
  end

  # POST /products
  def create
    authenticate_user!
    if current_user.role == 'admin' || current_user.role == 'seller'
    @product = Product.new(product_params)    
    if @product.save
      render json: @product, status: :created, location: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
    else
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
    end
  end

  # PATCH/PUT /products/1
  def update
    authenticate_user!

    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    authenticate_user!

    @product.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :quantity, :user_id)
    end


end
