class Api::V1::PostsController < ApplicationController
  before_action :set_post, only: %i[show update destroy]

  def index
    @posts = current_user&.posts
    render json: @posts
  end

  def filter
    if params[:status].present?
      @posts = current_user.posts.where(status: params[:status])
    else
      @posts = current_user.posts.all
    end

    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!

    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(:brand, :model, :body_type, :mileage, :color, :price, :fuel, :year, :engine_capacity, :phone_number, :name, :image)
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
