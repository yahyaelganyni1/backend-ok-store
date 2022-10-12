class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show update destroy ]

  # GET /reviews
  def index
    @reviews = Review.all
    # @average_rating = @reviews.map { |review| review.rating }.sum / @reviews.count

    render json:  @review
  end

  def product_reviews
    @reviews = Review.where(product_id: params[:product_id])
    
    @average_rating = @reviews.average(:rating)
    render json: { reviews: @reviews, average_rating: @average_rating }
  end

  # GET /reviews/1
  def show
    render json: @review
  end

  # POST /reviews
  def create
    authenticate_user!
    # every user can only review a product once
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @product_id = @review.product_id
    if Review.where(user_id: current_user.id, product_id: @product_id).exists?
      render json: { error: 'You have already reviewed this product' }, status: :unprocessable_entity
    else
      if @review.save
        render json: @review, status: :created, location: @review
      else
        render json: @review.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /reviews/1
  def update
    authenticate_user!
    if current_user.role == 'admin' ||  current_user.id == @review.user_id
      if @review.update(review_params)
        render json: @review
      else
        render json: @review.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
    end
  end

  # DELETE /reviews/1
  def destroy
    authenticate_user!
    if current_user.role == 'admin' ||  current_user.id == @review.user_id
    render json: { message: 'Review deleted' } if @review.destroy
    else
      render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:comment, :rating, :user_id, :product_id)
    end
end
