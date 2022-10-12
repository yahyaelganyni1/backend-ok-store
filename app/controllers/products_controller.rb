class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show update destroy ]
  # GET /products
  def index
    @products = Product.all.joins(:image_attachment).shuffle
    

    # render json: @products  
      render json: @products.map { |product|  
       product.as_json(only: %i[name price quantity user_id id category_id]).merge(
        image_path: url_for(product.image))  
      } 
  end

  # GET /products/1
  def show
    product = Product.find(params[:id])
    if @product.image.attached?
      render json: product.as_json(only: %i[name price quantity description user_id id ]).merge(
        image_path: url_for(product.image))
    else
      render json: product.as_json(only: %i[name price quantity  user_id id ])
    end
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
    @product_reviews = Review.where(product_id: @product.id)
    if current_user.role == 'admin' || (current_user.role == 'seller' && current_user.id == @product.user_id)
      @product.image.purge
      @product.destroy
      @product_reviews.destroy_all.each do |review|
        review.destroy
      end
      render json: { message: 'Product deleted successfully' }, status: :ok
    else
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized

    end
   
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :price, :quantity, :user_id, :image, :description, :category_id)
    end


end
